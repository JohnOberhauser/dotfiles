#!/usr/bin/env python3

import http.server
import socketserver
import threading

cond = threading.Condition()
version = 0


class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header(
            "Cache-Control", "no-store, no-cache, must-revalidate, max-age=0"
        )
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()

    def do_GET(self):
        if self.path == "/events":
            return self.stream_events()
        super().do_GET()

    def do_POST(self):
        global version
        if self.path == "/reload":
            with cond:
                version += 1
                cond.notify_all()
            self.send_response(204)
            self.end_headers()
        else:
            self.send_error(404)

    def stream_events(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/event-stream")
        self.end_headers()
        seen = version
        try:
            while True:
                with cond:
                    cond.wait_for(lambda: version != seen, timeout=15)
                    current = version
                if current != seen:
                    seen = current
                    self.wfile.write(b"event: css\ndata: reload\n\n")
                else:
                    self.wfile.write(b": ping\n\n")  # keepalive / detect closed tabs
                self.wfile.flush()
        except (BrokenPipeError, ConnectionResetError):
            pass


class Server(socketserver.ThreadingMixIn, socketserver.TCPServer):
    daemon_threads = True
    allow_reuse_address = True


if __name__ == "__main__":
    PORT = 10001
    with Server(("", PORT), Handler) as httpd:
        print(f"Serving no-cache on port {PORT}")
        httpd.serve_forever()
