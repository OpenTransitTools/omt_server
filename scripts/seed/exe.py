import argparse
import requests
from . import urls


def get_cmdline_args(prog_name='seed.run', do_parse=True):
    """
    """
    parser = argparse.ArgumentParser(
        prog=prog_name,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument('--lon', '-lon', '-x', type=float, default=-122.67, help='')
    parser.add_argument('--lat', '-lat', '-y', type=float, default=45.52,   help='')
    parser.add_argument('--radius',      '-r', type=int, default=0, help='size of the multiplier to apply to the coordinate to spread out the tiles')
    parser.add_argument('--from_zoom',   '-fz', type=int, default=15, help='lowest zoom level to seed')
    parser.add_argument('--to_zoom',     '-tz', type=int, default=15,   help='highest zoom level to seed')
    parser.add_argument('--zoom',        '-z',  type=int, default=None, help='single zoom layer')
    parser.add_argument('--url',    '-u', type=str, default="https://tiles-st.trimet.org", help='tilecache server to seed')
    parser.add_argument('--style',  '-s', type=str, default="trimet", help='style layer (as opposed to data layer for vector maps)')
    parser.add_argument('--data',   '-d', type=str, default=None,     help='data vector layer (if specified, style is ignored)')
    parser.add_argument('--wait',   '-w', type=int, default=0.03, help='TBD time between "curl" layer requests (see -curl)')
    parser.add_argument('--max',    '-m', type=int, default=300, help='limit to number of requests')
    parser.add_argument('--retina', '-2x', '-hi-rez', '-hr', action='store_true', help='create the @2x tiles')
    parser.add_argument('--both',   '-b', action='store_true', help='create both normal and @2x tiles')
    parser.add_argument('--stats',  '-stats', '-st', action='store_true', help='print seed url stats')
    parser.add_argument('--print',  '-print', '-p',  action='store_true', help='print seed urls')
    parser.add_argument('--stops',  '-stops', '-ss', action='store_true', help='read lat lon from stops.txt')
    parser.add_argument('--curl',   '-curl',  '-c',  action='store_true', help='"curl" the url, ala seed the cache')

    if do_parse:
        args = parser.parse_args()
    else:
        args = parser
    return args


def curl(urls, sleep=0):
    def pprint(str):
        print(str, end="", flush=True)
    
    for u in urls:
        try:
            response = requests.get(u)
            if response.ok:
                pprint(".")
            else:
                pprint("_")
        except Exception as e:
            #print(e)
            pprint("#")


def seeder(args):
    if args.zoom:
        from_zoom = to_zoom = args.zoom
    else:
        from_zoom = args.from_zoom
        to_zoom = args.to_zoom
        
    seed_urls = []    
    for zoom in range(from_zoom, to_zoom+1):
        minlat, minlon, maxlat, maxlon = urls.crazy_extent_calc(zoom, args.lat, args.lon, args.radius)

        # get seed urls
        u = urls.get_seed_urls(minlat, minlon, maxlat, maxlon, zoom, args.url, args.style, args.data, args.retina, args.max)
        if args.both and args.data is None:
            z = urls.get_seed_urls(minlat, minlon, maxlat, maxlon, zoom, args.url, args.style, args.data, not args.retina, args.max)
            u += z

        # collect urls
        seed_urls += u

        # optional print stats and/or urls
        if args.stats:
            print("zoom level: {} = {} ({})".format(zoom, len(u), u[0]))
        if args.print:
            print(*u, sep="\n")

    if args.stats:
        print("\ntotal urls: {} seed urls generated for point {},{} at zoom levels {}-{}, with radius of {}\n\n".format(len(seed_urls), args.lat, args.lon, from_zoom, to_zoom, args.radius))

    if args.curl:
        curl(seed_urls)
        print()


def print_stops(args):
    import csv
    with open('stops.txt', 'r') as file:
        reader = csv.DictReader(file)
        fn = reader.fieldnames
        for row in reader:
            if row and "MAX" in row.get('stop_name'):
                print("seed.sh -lat {} -lon {} $*".format(row.get('stop_lat'), row.get('stop_lon')), sep='')


if __name__ == "__main__":
    cmdline_args = get_cmdline_args()
    if cmdline_args.stops:
        print_stops(cmdline_args)
    else:
        seeder(cmdline_args)
