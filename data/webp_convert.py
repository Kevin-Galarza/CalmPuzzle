import os
import sys
from PIL import Image

# USAGE: python3 convert_images.py <path/to/input_directory> <png/jpg>

def convert_images(input_dir, output_format):
    # Ensure output format is either 'png' or 'jpg'
    if output_format not in ['png', 'jpg']:
        print("Output format must be either 'png' or 'jpg'")
        return
    
    # Create output directory
    output_dir = f"{input_dir}_converted_to_{output_format}"
    os.makedirs(output_dir, exist_ok=True)
    
    # Process each image in the input directory
    for filename in os.listdir(input_dir):
        if filename.endswith(".webp"):
            input_path = os.path.join(input_dir, filename)
            output_path = os.path.join(output_dir, f"{os.path.splitext(filename)[0]}.{output_format}")
            
            # Open the image and convert it
            with Image.open(input_path) as img:
                img.save(output_path, output_format.upper())
                
            print(f"Converted {input_path} to {output_path}")

if __name__ == "__main__":
    # Get input arguments
    if len(sys.argv) != 3:
        print("Usage: python convert_images.py <input_directory> <output_format>")
    else:
        input_directory = sys.argv[1]
        output_format = sys.argv[2]
        convert_images(input_directory, output_format)
