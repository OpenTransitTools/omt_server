from . import maptile


def main():
    import sys
    #print(sys.argv)
    
    " https://tiles-st.trimet.org/styles/trimet/18/41742/93764@2x.png "
    zoomlevel, lat, lon, latmax, lonmax, boundingbox = maptile.params(sys.argv)
    mercator = maptile.GlobalMercator()

    mx, my = mercator.LatLonToMeters( lat, lon )
    tminx, tminy = mercator.MetersToTile( mx, my, zoomlevel )
    if boundingbox:
        mx, my = mercator.LatLonToMeters( latmax, lonmax )
        tmaxx, tmaxy = mercator.MetersToTile( mx, my, zoomlevel )
    else:
        tmaxx, tmaxy = tminx, tminy

    url = "http://tiles-st.trimet.org"
    style = "trimet"

    for ty in range(tminy, tmaxy+1):
        for tx in range(tminx, tmaxx+1):
            gx, gy = mercator.GoogleTile(tx, ty, zoomlevel)
            tilefilename = "{}/styles/{}/{}/{}/{}".format(url, style, zoomlevel, gx, gy)
            print (tilefilename + ".png")
            print (tilefilename + "@2x.png")


if __name__ == "__main__":
    main()
