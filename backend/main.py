from typing import Optional
import glob
from fastapi import FastAPI
from fastapi.responses import FileResponse
from PIL import Image

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/image")
async def read_item(lat: str = "", lon: str = ""):
    # filepaths
    fp_in = "./images/*.jpg"
    fp_out = f"./gifs/gif{lat}{lon}.gif"
    imgs = (Image.open(f) for f in sorted(glob.glob(fp_in)))
    img = next(imgs)  # extract first image from iterator
    img.save(fp=fp_out, format='GIF', append_images=imgs,
             save_all=True, duration=200, loop=0)
    return FileResponse(fp_out)
