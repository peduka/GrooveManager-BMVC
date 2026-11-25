from app.controllers.application import Application
from bottle import Bottle, run, static_file


app = Bottle()
ctl = Application()


# -----------------------------------------------------------------------------
# Rotas:

@app.route('/static/<filepath:path>')
def serve_static(filepath):
    return static_file(filepath, root='./app/static')


@app.route('/helper')
def helper():
    return ctl.render('helper')


# -----------------------------------------------------------------------------
# Rotas do GrooveManager (BMVC I):

@app.route('/')
def index():
    return ctl.render('index')


# -----------------------------------------------------------------------------

if __name__ == '__main__':
    run(app, host='localhost', port=8080, debug=True, reloader=True)