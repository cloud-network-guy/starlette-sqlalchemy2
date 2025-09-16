from traceback import format_exc
from starlette.applications import Starlette
from starlette.routing import Route
from starlette.requests import Request
from starlette.responses import JSONResponse, PlainTextResponse

CONTENT = {'hello': 'world'}
HEADERS = {
    'Access-Control-Allow-Origin': '*',
    'Cache-Control': "no-cache, no-store",
    'Pragma': "no-cache"
}

async def _root(req: Request):

    try:
        return JSONResponse(content=CONTENT, headers=HEADERS)
    except Exception as e:
        return PlainTextResponse(content=format_exc(), status_code=500)

APP_ROUTES = [
    Route('/', _root, methods=["GET"]),
]

app = Starlette(debug=True, routes=APP_ROUTES)

if __name__ == '__main__':

    import uvicorn

    uvicorn.run(
        app=app,
        host='0.0.0.0',
        port=8000,
        #reload=True,
        proxy_headers=True,
        forwarded_allow_ips='*',
        log_level="info"
    )
