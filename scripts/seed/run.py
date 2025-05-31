from . import maptile
import argparse


def get_cmdline_args(prog_name='seed.run', do_parse=True):
    """
    """
    parser = argparse.ArgumentParser(
        prog=prog_name,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument('--lon', '-lon', '-x', type=float, default=-122.67, help='')
    parser.add_argument('--lat', '-lat', '-y', type=float, default=45.52,   help='')
    parser.add_argument('--radius',      '-r', type=int, default=0, help='size of the multiplier to apply to the coordinate to spead out the tiles')
    parser.add_argument('--from_zoom',   '-fz', type=int, default=15, help='lowest zoom level to seed')
    parser.add_argument('--to_zoom',     '-tz', type=int, default=15,   help='highest zoom level to seed')
    parser.add_argument('--zoom',        '-z',  type=int, default=None, help='single zoom layer')
    parser.add_argument('--url',    '-u', type=str, default="http://tiles-st.trimet.org", help='url to seed')
    parser.add_argument('--style',  '-s', type=str, default="trimet", help='style')
    parser.add_argument('--wait',   '-w', type=int, default=3, help='time between layer requests')
    parser.add_argument('--max',    '-m', type=int, default=300, help='limit to number of requests')
    parser.add_argument('--retina', '-2x', action='store_true', help='creat the @2x tiles')

    if do_parse:
        args = parser.parse_args()
    else:
        args = parser
    return args


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
            url = "{}/styles/{}/{}/{}/{}{}".format(url, style, zoomlevel, gx, gy, ext)
            ret_val.append(url)
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
    #print(zoom)
    # crazy logic to extend the lat lon bbox and not genereate too many tiles
    if radius > 1 and zoom < len(mult):
        if mult[zoom] == 0:
            minlat, minlon, maxlat, maxlon = max_extent()
        else:
            minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon, radius * mult[zoom])
    else:
        minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon)
    return minlat, minlon, maxlat, maxlon


def runner(args):
    if args.zoom:
        from_zoom = to_zoom = args.zoom
    else:
        from_zoom = args.from_zoom
        to_zoom = args.to_zoom
        
    url_count = 0
    for zoom in range(from_zoom, to_zoom+1):
        minlat, minlon, maxlat, maxlon = crazy_extent_calc(zoom, args.lat, args.lon, args.radius)
        urls = get_seed_urls(minlat, minlon, maxlat, maxlon, zoom, args.url, args.style, args.retina, args.max)
        url_count += len(urls)
        print("zoom level: {} = {} ({})".format(zoom, len(urls), urls[0]))

    print("total urls: {} for zooms {}-{} and scale of {}".format(url_count, from_zoom, to_zoom, args.radius))

if __name__ == "__main__":
    cmdline_args = get_cmdline_args()    
    runner(cmdline_args)
