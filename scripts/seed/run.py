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


def crazy_extent_calc(zoom, lat, lon, radius):
    minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon)
    # crazy logic to extend the lat lon bbox and not genereate too many tiles
    if radius > 1:
        if zoom <= 4:
            minlat, minlon, maxlat, maxlon = max_extent()
        elif zoom < 7:
            minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon, radius * 3.00)
        elif zoom < 9:
            minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon, radius * 0.55)
        elif zoom < 12:
            minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon, radius * 0.10)
        elif zoom < 14:
            minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon, radius * 0.03)
        elif zoom < 17:
            minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon, radius * 0.0035)
        elif zoom < 20:
            minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon, radius * 0.0005)
        elif zoom < 25:
            minlat, minlon, maxlat, maxlon = pt_2_bbox(lat, lon, radius * 0.00009)
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
