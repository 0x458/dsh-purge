#!/usr/bin/env python3
"""远程 AI 通过 HTTP 跑命令 / 读文件。GET /run?token=..&cmd=.. | /read?path=.. | /ping"""
import base64, html, os, subprocess
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse, parse_qs

TOKEN = os.environ.get("BRIDGE_TOKEN", "dshbridge")
PORT  = int(os.environ.get("BRIDGE_PORT", "8899"))
HOME  = os.path.expanduser("~")

def page(t, x):
    return ("<!doctype html><meta charset=utf-8><title>%s</title><pre>%s</pre>"
            % (html.escape(t), html.escape(x)))

class H(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"
    def reply(self, body, code=200):
        b = body.encode()
        self.send_response(code)
        self.send_header("content-type", "text/html; charset=utf-8")
        self.send_header("content-length", str(len(b)))
        self.end_headers(); self.wfile.write(b)
    def do_GET(self):
        u = urlparse(self.path); q = parse_qs(u.query)
        if q.get("token", [""])[0] != TOKEN:
            return self.reply(page("403", "bad token"), 403)
        if u.path == "/ping":
            return self.reply(page("ok", "ok"))
        if u.path == "/read":
            p = q.get("path", [""])[0]
            try: txt = open(p, errors="replace").read()
            except Exception as e: txt = "ERROR: %r" % e
            return self.reply(page("read " + p, txt))
        if u.path == "/run":
            cmd = q.get("cmd", [""])[0]
            if q.get("b64"): cmd = base64.b64decode(q["b64"][0]).decode()
            cwd = q.get("cwd", [HOME])[0]
            tmo = int(q.get("timeout", ["120"])[0])
            try:
                p = subprocess.run(["bash", "-lc", cmd], cwd=cwd, text=True,
                                   capture_output=True, timeout=tmo)
                out = p.stdout
                if p.stderr: out += "\n--- stderr ---\n" + p.stderr
                out += "\n[exit %d]" % p.returncode
            except subprocess.TimeoutExpired as e:
                out = "[timeout %ss]\n%s" % (tmo, e.stdout or "")
            return self.reply(page("run", out))
        return self.reply(page("404", "no such path"), 404)
    def log_message(self, *a): pass

if __name__ == "__main__":
    print("dsh-bridge on 0.0.0.0:%d" % PORT)
    ThreadingHTTPServer(("0.0.0.0", PORT), H).serve_forever()
