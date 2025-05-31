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
    parser.add_argument('--max',    '-m', type=int, default=100, help='limit to number of requests')
    parser.add_argument('--retina', '-2x', action='store_true', help='creat the @2x tiles')

    if do_parse:
        args = parser.parse_args()
    else:
        args = parser
    return args

    
def seed_layer(minlat, minlon, maxlat, maxlon, zoomlevel, url, style, retina):
    " https://tiles-st.trimet.org/styles/trimet/18/41742/93764@2x.png "
    mercator = maptile.GlobalMercator()

    mx, my = mercator.LatLonToMeters( minlat, minlon )
    tminx, tminy = mercator.MetersToTile( mx, my, zoomlevel )

    mx, my = mercator.LatLonToMeters( maxlat, maxlon )
    tmaxx, tmaxy = mercator.MetersToTile( mx, my, zoomlevel )

    for ty in range(tminy, tmaxy+1):
        for tx in range(tminx, tmaxx+1):
            gx, gy = mercator.GoogleTile(tx, ty, zoomlevel)
            tilefilename = "{}/styles/{}/{}/{}/{}".format(url, style, zoomlevel, gx, gy)
            if retina:
                print (tilefilename + "@2x.png")
            else:
                print (tilefilename + ".png")


def runner(args):
    minlat = maxlat = args.lat
    minlon = maxlon = args.lon

    if args.zoom:
        from_zoom = to_zoom = args.zoom
    else:
        from_zoom = args.from_zoom
        to_zoom = args.to_zoom
        
    for zoom in range(from_zoom, to_zoom+1):
        # crazy logic to extend the lat lon bbox and not genereate too many tiles
        if zoom >= 25:
            break
        if args.radius > 1:
            if zoom < 5:
                mult = 1.0
                radius = 40.0
            elif zoom < 8:
                mult = 1.0
                radius = 80.0 / args.radius
            elif zoom < 13:
                mult = 1 / zoom
                radius = args.radius * 20 / zoom 
            elif zoom < 17:
                mult = .05 / zoom 
                radius = args.radius * 20 / zoom 
            elif zoom > 19:
                mult = .2
                radius = .3 * (20 / zoom) /(args.radius * zoom)
            else: 
                mult = 0.01 / zoom + 0.0001 * args.radius / zoom
                radius = args.radius * 20 / zoom 
            minlat -= (mult * radius)
            maxlat += (mult * radius)
            minlon -= (mult * radius)
            maxlon += (mult * radius)

        seed_layer(minlat, minlon, maxlat, maxlon, zoom, args.url, args.style, args.retina)


if __name__ == "__main__":
    args = get_cmdline_args()    
    runner(args)
