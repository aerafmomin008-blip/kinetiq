from flask import Flask, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv
from google import genai

import os
import json
import base64


# Load .env file
load_dotenv()


# Flask app
app = Flask(__name__)
CORS(app)


# Gemini client
api_key = os.getenv("GEMINI_API_KEY")

if api_key:
    client = genai.Client(api_key=api_key)
else:
    client = None


@app.route("/")
def home():
    return jsonify({
        "message": "Welcome to KinetIQ API",
        "status": "running"
    })


@app.route("/api/health")
def health():
    return jsonify({
        "app": "KinetIQ",
        "status": "healthy"
    })


def get_image_mime_type(image):
    """
    Detect image type safely.

    Browser uploads may sometimes send an incorrect
    or empty MIME type, so filename extension is also checked.
    """

    mime_type = (image.mimetype or "").lower()

    allowed_types = {
        "image/jpeg",
        "image/png",
        "image/webp"
    }

    if mime_type in allowed_types:
        return mime_type

    filename = (image.filename or "").lower()

    if filename.endswith(".jpg") or filename.endswith(".jpeg"):
        return "image/jpeg"

    if filename.endswith(".png"):
        return "image/png"

    if filename.endswith(".webp"):
        return "image/webp"

    return None


@app.route("/api/analyze-meal", methods=["POST"])
def analyze_meal():

    try:

        # --------------------------------------------------
        # 1. Check image
        # --------------------------------------------------

        if "image" not in request.files:
            return jsonify({
                "success": False,
                "error": "No image uploaded"
            }), 400

        image = request.files["image"]

        if not image.filename:
            return jsonify({
                "success": False,
                "error": "Invalid image"
            }), 400


        # --------------------------------------------------
        # 2. Detect image type
        # --------------------------------------------------

        mime_type = get_image_mime_type(image)

        if not mime_type:
            return jsonify({
                "success": False,
                "error": "Unsupported image. Please upload JPG, PNG or WEBP."
            }), 400


        # --------------------------------------------------
        # 3. Read image
        # --------------------------------------------------

        image_bytes = image.read()

        if not image_bytes:
            return jsonify({
                "success": False,
                "error": "Empty image"
            }), 400


        # Maximum image size = 10 MB

        if len(image_bytes) > 10 * 1024 * 1024:
            return jsonify({
                "success": False,
                "error": "Image must be smaller than 10 MB"
            }), 400


        # --------------------------------------------------
        # 4. Check Gemini API key
        # --------------------------------------------------

        if not api_key or client is None:
            return jsonify({
                "success": False,
                "error": "GEMINI_API_KEY is not configured"
            }), 500


        # --------------------------------------------------
        # 5. Convert image to Base64
        # --------------------------------------------------

        encoded_image = base64.b64encode(
            image_bytes
        ).decode("utf-8")


        # --------------------------------------------------
        # 6. Nutrition AI prompt
        # --------------------------------------------------

        prompt = """
You are KinetIQ's professional nutrition estimation AI.

Analyze the food shown in the image.

Your job is to:

1. Identify the most likely food items.
2. Estimate the portion or serving size of each visible food item.
3. Estimate calories, protein, carbohydrates and fats for each item.
4. Calculate total nutrition for the complete visible meal.
5. Give a confidence score between 0 and 1.

Return ONLY valid JSON.

Use exactly this structure:

{
  "name": "meal name",
  "items": [
    {
      "name": "food item",
      "quantity": "estimated portion",
      "calories": 0,
      "protein": 0,
      "carbs": 0,
      "fats": 0
    }
  ],
  "calories": 0,
  "protein": 0,
  "carbs": 0,
  "fats": 0,
  "confidence": 0
}

Rules:

- calories must be an integer.
- protein, carbs and fats must be numbers in grams.
- confidence must be a number between 0 and 1.
- Estimate the complete visible serving.
- If multiple foods are visible, identify them separately.
- Use reasonable nutritional estimates.
- Do not invent extremely precise quantities when the image does not allow it.
- If portion size is uncertain, make a reasonable visual estimate.
- Total nutrition should approximately match the sum of individual items.
- Do not include markdown.
- Do not include explanations outside the JSON.
"""


        # --------------------------------------------------
        # 7. Send image to Gemini
        # --------------------------------------------------

        response = client.models.generate_content(
            model="gemini-3.6-flash",
            contents=[
                {
                    "text": prompt
                },
                {
                    "inline_data": {
                        "mime_type": mime_type,
                        "data": encoded_image
                    }
                }
            ]
        )


        # --------------------------------------------------
        # 8. Read Gemini response
        # --------------------------------------------------

        raw_output = response.text.strip()


        # Remove markdown code fences if Gemini adds them

        if raw_output.startswith("```"):

            raw_output = raw_output.replace(
                "```json",
                ""
            )

            raw_output = raw_output.replace(
                "```",
                ""
            )

            raw_output = raw_output.strip()


        # --------------------------------------------------
        # 9. Convert response to JSON
        # --------------------------------------------------

        nutrition = json.loads(raw_output)


        # --------------------------------------------------
        # 10. Validate required fields
        # --------------------------------------------------

        required_fields = [
            "name",
            "items",
            "calories",
            "protein",
            "carbs",
            "fats",
            "confidence"
        ]

        for field in required_fields:

            if field not in nutrition:
                raise ValueError(
                    f"Missing field: {field}"
                )


        # --------------------------------------------------
        # 11. Clean individual food items
        # --------------------------------------------------

        cleaned_items = []

        for item in nutrition.get("items", []):

            cleaned_items.append({

                "name": str(
                    item.get(
                        "name",
                        "Unknown food"
                    )
                ),

                "quantity": str(
                    item.get(
                        "quantity",
                        "Unknown portion"
                    )
                ),

                "calories": int(
                    item.get(
                        "calories",
                        0
                    )
                ),

                "protein": float(
                    item.get(
                        "protein",
                        0
                    )
                ),

                "carbs": float(
                    item.get(
                        "carbs",
                        0
                    )
                ),

                "fats": float(
                    item.get(
                        "fats",
                        0
                    )
                )
            })


        # --------------------------------------------------
        # 12. Return result to Flutter
        # --------------------------------------------------

        return jsonify({

            "success": True,

            "meal": {

                "name": str(
                    nutrition["name"]
                ),

                "items": cleaned_items,

                "calories": int(
                    nutrition["calories"]
                ),

                "protein": float(
                    nutrition["protein"]
                ),

                "carbs": float(
                    nutrition["carbs"]
                ),

                "fats": float(
                    nutrition["fats"]
                ),

                "confidence": float(
                    nutrition["confidence"]
                )
            }
        })


    # ------------------------------------------------------
    # JSON error
    # ------------------------------------------------------

    except json.JSONDecodeError:

        return jsonify({

            "success": False,

            "error": "AI returned invalid nutrition data"

        }), 500


    # ------------------------------------------------------
    # General error
    # ------------------------------------------------------

    except Exception as e:

        print(
            "MEAL ANALYZER ERROR:",
            str(e)
        )

        return jsonify({

            "success": False,

            "error": str(e)

        }), 500


# ----------------------------------------------------------
# Run Flask
# ----------------------------------------------------------

if __name__ == "__main__":

    app.run(
        host="127.0.0.1",
        port=5000,
        debug=True
    )