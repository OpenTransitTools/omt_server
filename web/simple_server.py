"""Use instead of `python3 -m http.server` when you need CORS"""
import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler


class CORSRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET')
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate')
        return super(CORSRequestHandler, self).end_headers()


port = sys.argv[1] if len(sys.argv) > 1 else 8070
httpd = HTTPServer(('localhost', port), CORSRequestHandler)
httpd.serve_forever()
