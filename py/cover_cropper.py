import os 
import sys
from PIL import Image,ImageDraw

def add_to_filename(filepath, code) : 
    root, extension = os.path.splitext(filepath)
    return f"{root}{code}{extension}"

def generate_image():

    if len(sys.argv) != 3:
        raise Exception("File path and output path args must be provided")

    image_path = sys.argv[1]
    cover_filename = 'cover.png'
    cover_resize = False
    top_crop = 100
    bottom_crop = 0
    left_crop = 100
    right_crop = 100
    overwrite = False
    
    image = Image.open(image_path)
    
    width, height = image.size
    
    image = image.crop((left_crop, top_crop, width-right_crop, height-bottom_crop))
    
    width, height = image.size
    
    if width != height : 
        new_width = min(width, height)
        new_height = min(width, height)
        left = (width - new_width)/2
        top = (height - new_height)/2
        right = (width + new_width)/2
        bottom = (height + new_height)/2

        image = image.crop((left, top, right, bottom))
        
    if cover_resize: 
        image = image.resize((440,440))
    
    width, height = image.size
    
    output = Image.new("RGBA", image.size, (0, 0, 0, 0))
    
    mask = Image.new("L", image.size, 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse((0, 0, image.size[0], image.size[1]), fill=255)
    
    cropped = Image.new("RGBA", image.size)
    cropped.paste(image, mask=mask)
    
    output.paste(cropped, (0, 0), mask=mask)
    #thumbnail = cropped.copy()  # Make a copy to avoid modifying the original image
    #thumbnail.thumbnail((300, 300))
    
    out_filename = cover_filename
    output_dir= sys.argv[2]
    output_filepath = os.path.join(output_dir, out_filename)
    
    if os.path.exists(output_filepath):
        if overwrite : 
            os.remove(output_filepath)
        else : 
            print(f'{output_filepath} already exists. Change filename.')
            
            
            index=1
            while os.path.exists(output_filepath):
                output_filepath = os.path.join(output_dir, add_to_filename(out_filename, f" ({index})"))
                index += 1
            if index > 100 : 
                raise Exception('Cannot change filename')
    
    
    cropped.save(output_filepath)

    print(f"Image successfully generated in {output_filepath}.")
            
            
if __name__ =='__main__' : 
    generate_image()

# Thanks for the code Stormberry :3