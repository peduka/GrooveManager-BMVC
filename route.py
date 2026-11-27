from app.controllers.application import Application
from bottle import Bottle, run, static_file


app = Bottle()
ctl = Application()


# -----------------------------------------------------------------------------
# Rotas estáticas e utilitárias:

@app.route('/static/<filepath:path>')
def serve_static(filepath):
    return static_file(filepath, root='./app/static')


@app.route('/helper')
def helper():
    return ctl.render('helper')


# -----------------------------------------------------------------------------
# Rotas públicas e autenticação (BMVC III):

@app.route('/')
def index():
    return ctl.render('index')


@app.get('/login')
def pagina_login():
    return ctl.pagina_login()


@app.post('/login')
def autenticar():
    return ctl.autenticar()


@app.post('/cadastro')
def registrar_usuario():
    return ctl.registrar_usuario()


@app.get('/logout')
def logout():
    return ctl.logout()


# -----------------------------------------------------------------------------
# Rotas restritas (exigem login ativo):

@app.get('/acervo')
def acervo_restrito():
    return ctl.acervo_restrito()


@app.post('/midias/criar')
def criar_midia():
    return ctl.criar_midia()


@app.get('/midias/editar/<midia_id:int>')
def pagina_editar(midia_id):
    return ctl.pagina_editar(midia_id)


@app.post('/midias/editar/<midia_id:int>')
def atualizar_midia(midia_id):
    return ctl.atualizar_midia(midia_id)


@app.post('/midias/excluir/<midia_id:int>')
def excluir_midia(midia_id):
    return ctl.excluir_midia(midia_id)


# -----------------------------------------------------------------------------

if __name__ == '__main__':
    run(app, host='localhost', port=8080, debug=True, reloader=True)