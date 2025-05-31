from . import maptile


def factor_bbox(minlat, maxlat, minlon, maxlon, factor=0.0):
    minlat -= factor
    maxlat += factor
    minlon -= factor
    maxlon += factor
    return minlat, minlon, maxlat, maxlon


def pt_2_bbox(lat, lon, factor=0.0):
    return factor_bbox(lat, lat, lon, lon, factor)
    

def max_extent():
    return factor_bbox(-45.0, 45.0, -180.0, 180.0)


def get_seed_urls(minlat, minlon, maxlat, maxlon, zoomlevel, url, style, retina, max_urls):
    " https://tiles-st.trimet.org/styles/trimet/18/41742/93764@2x.png "
    ret_val = []

    mercator = maptile.GlobalMercator()

    mx, my = mercator.LatLonToMeters( minlat, minlon )
    tminx, tminy = mercator.MetersToTile( mx, my, zoomlevel )

    mx, my = mercator.LatLonToMeters( maxlat, maxlon )
    tmaxx, tmaxy = mercator.MetersToTile( mx, my, zoomlevel )
    
    ext = "@2x.png" if retina else ".png"

    for ty in range(tminy, tmaxy+1):
        for tx in range(tminx, tmaxx+1):
            gx, gy = mercator.GoogleTile(tx, ty, zoomlevel)
            u = "{}/styles/{}/{}/{}/{}{}".format(url, style, zoomlevel, gx, gy, ext)
            ret_val.append(u)
        if len(ret_val) > max_urls:
            break
    
    return ret_val


# multiplyer table for different zoom levels
mult = [0] * 26
mult[4]  = 4.35
mult[5]  = 2.35
mult[6]  = 1.0
mult[7]  = 0.50
mult[8]  = 0.3
mult[9]  = 0.15
mult[10] = 0.075
mult[11] = 0.037
mult[12] = 0.015
mult[13] = 0.0095
mult[14] = 0.005
mult[15] = 0.0025
mult[16] = 0.00115
mult[17] = 0.00055
mult[18] = 0.00025
mult[19] = 0.00015
mult[20] = 0.000065
mult[21] = 0.00003609
mult[22] = 0.0000175
mult[23] = 0.000010
mult[24] = 0.000005
mult[25] = 0.0000025


def crazy_extent_calc(zoom, lat, lon, radius):
    if radius > 10:
        radius = 10

    # crazy logic to extend the lat lon bbox and not genereate too many tiles
    if radius > 1 and zoom < len(mult):
        if mult[zoom] == 0:
            minlat, minlon, maxlat, maxlon = max_extent()
        else:
            minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon, radius * mult[zoom])
    else:
        minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon)
    return minlat, minlon, maxlat, maxlon
