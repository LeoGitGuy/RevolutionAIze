# conda install -c conda-forge owslib
#from make_prediction import torch, get_device, classify_image
from make_prediction import *
from tqdm import tqdm
from PIL import Image, ImageDraw
import matplotlib
import numpy as np
import matplotlib.pyplot as plt
from owslib.wms import WebMapService
wms = WebMapService(
    'https://tiles.maps.eox.at/wms?service=wms&request=getcapabilities', version='1.1.1')


# path to model
PATH = "model1.pt"
loaded_model = torch.load(PATH, map_location=get_device())


def classifier_forest(im, dummy=False):
    if not dummy:
        pred = classify_image(im, loaded_model)
        return pred == 'Forest'

    else:
        arr = np.asarray(im)
        return np.mean(arr) <= 50


def sliding_window(image, stride=64, imgSize=64, dummy_classification=False):
    width, height = image.size
    for y in range(0, height-imgSize, stride):
        for x in range(0, width-imgSize, stride):
            # Setting the points for cropped image
            left = x
            top = y
            right = x + imgSize
            bottom = y + imgSize
            im1 = image.crop((left, top, right, bottom))
            draw = ImageDraw.Draw(image)
            is_forest = classifier_forest(im1, dummy=dummy_classification)
            if is_forest:
                pass
                #color = 'green'
                #color = (0, 255, 0, 20)
            else:
                #color = 'red'
                color = (255, 0, 0, 1)
                draw.rectangle([(left, top), (right, bottom)],
                               outline=color, fill=None, width=2)
            yield im1, is_forest


def get_coord_box(lat, lon, dn=640, de=640):
    # https://gis.stackexchange.com/questions/2951/algorithm-for-offsetting-a-latitude-longitude-by-some-amount-of-meters
    R = 6378137
    dLat = dn/R
    dLon = de / (R*np.cos(np.pi*lat/180))
    lat = lat - dLat*180/np.pi/2
    lon = lon - dLon*180/np.pi/2
    latO = lat + dLat*180/np.pi
    lonO = lon + dLon*180/np.pi

    return lat, lon, latO, lonO


def get_image(lat, lon, dn=640, de=640, year='2020', size=223):
    a, b, c, d = get_coord_box(lon, lat, dn, de)
    img = wms.getmap(layers=[f's2cloudless-{year}'],
                     styles=['visual_bright'],
                     srs='EPSG:4326',
                     bbox=(a, b, c, d),
                     #size=(64, 64),
                     size=(size, size),
                     format='image/jpeg',
                     transparent=True
                     )
    out = open('./image_tmp.jpg', 'wb')
    out.write(img.read())
    im = Image.open('./image_tmp.jpg')
    return im


def get_area(lat, lon, n_tiles=20, year='2020'):
    dn = 640*n_tiles
    de = dn
    size = n_tiles*64+1
    i1 = get_image(lat, lon, year=year, dn=dn, de=de, size=size)

    return i1


# 6 images: 3 of inage and 3 of classification
# three years
# clouds issue
