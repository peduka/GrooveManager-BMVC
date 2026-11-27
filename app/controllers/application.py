from bottle import redirect, request, response, template
from app.models.midia import AcervoRepositorio
from app.models.usuario import Usuario, UsuarioRepositorio


class Application:

    SECRET_KEY = "groovemanager-unb-fga-bmvc3-secret"
    COOKIE_NAME = "gm_usuario_id"

    def __init__(self):
        self.repositorio = AcervoRepositorio()
        self.usuarios = UsuarioRepositorio()
        self.pages = {
            'index': self.index,
            'helper': self.helper,
        }

    def render(self, page):
        content = self.pages.get(page, self.index)
        return content()

    # -------------------------------------------------------------------------
    # Controle de Sessão / Autenticação
    # -------------------------------------------------------------------------

    def _usuario_atual(self) -> Usuario | None:
        user_id = request.get_cookie(self.COOKIE_NAME, secret=self.SECRET_KEY)
        if not user_id:
            return None
        try:
            return self.usuarios.buscar_por_id(int(user_id))
        except (ValueError, TypeError):
            return None

    def _exigir_login(self) -> Usuario:
        usuario = self._usuario_atual()
        if not usuario:
            redirect('/login?msg=acesso_restrito')
        return usuario

    # -------------------------------------------------------------------------
    # Páginas Públicas (Vitrine e Login/Cadastro)
    # -------------------------------------------------------------------------

    def index(self):
        usuario = self._usuario_atual()
        midias = self.repositorio.listar_midias()
        valor_total = sum(m.registro_compra.valor for m in midias)
        return template(
            'app/views/html/index',
            usuario=usuario,
            midias=midias,
            valor_total=valor_total,
        )

    def pagina_login(self):
        if self._usuario_atual():
            redirect('/acervo')
        aviso = request.query.get('msg', '')
        return template('app/views/html/login', aviso=aviso)

    def autenticar(self):
        username = request.forms.getunicode('username', '').strip()
        senha = request.forms.getunicode('senha', '')
        usuario = self.usuarios.autenticar(username, senha)

        if not usuario:
            redirect('/login?msg=credenciais_invalidas')

        response.set_cookie(
            self.COOKIE_NAME,
            str(usuario.id),
            secret=self.SECRET_KEY,
            path='/',
            httponly=True,
        )
        redirect('/acervo?msg=bem_vindo')

    def registrar_usuario(self):
        nome = request.forms.getunicode('nome', '').strip()
        username = request.forms.getunicode('username', '').strip()
        senha = request.forms.getunicode('senha', '')

        usuario = self.usuarios.cadastrar(nome, username, senha)
        if not usuario:
            redirect('/login?msg=erro_cadastro')

        response.set_cookie(
            self.COOKIE_NAME,
            str(usuario.id),
            secret=self.SECRET_KEY,
            path='/',
            httponly=True,
        )
        redirect('/acervo?msg=conta_criada')

    def logout(self):
        response.delete_cookie(self.COOKIE_NAME, path='/')
        redirect('/login?msg=saiu')

    # -------------------------------------------------------------------------
    # Área Restrita (CRUD Completo protegido por Login)
    # -------------------------------------------------------------------------

    def acervo_restrito(self):
        usuario = self._exigir_login()
        midias = self.repositorio.listar_midias()
        valor_total = sum(m.registro_compra.valor for m in midias)
        aviso = request.query.get('msg', '')
        return template(
            'app/views/html/acervo',
            usuario=usuario,
            midias=midias,
            valor_total=valor_total,
            aviso=aviso,
        )

    def criar_midia(self):
        self._exigir_login()
        formato = request.forms.getunicode('formato', 'Vinil')
        titulo = request.forms.getunicode('titulo', '').strip()
        nome_artista = request.forms.getunicode('artista', '').strip()
        pais_origem = request.forms.getunicode('pais_origem', '').strip()
        ano_lancamento = request.forms.getunicode('ano_lancamento', '').strip()
        estado_conservacao = request.forms.getunicode('estado_conservacao', 'Excelente')
        data_prensagem = request.forms.getunicode('data_prensagem', '').strip()
        local_prensagem = request.forms.getunicode('local_prensagem', '').strip()

        try:
            valor = float(request.forms.get('valor', '0').replace(',', '.'))
        except ValueError:
            valor = 0.0

        if titulo and nome_artista and ano_lancamento:
            self.repositorio.adicionar_midia(
                formato=formato,
                titulo=titulo,
                nome_artista=nome_artista,
                pais_origem=pais_origem,
                ano_lancamento=ano_lancamento,
                estado_conservacao=estado_conservacao,
                valor=valor,
                data_prensagem=data_prensagem,
                local_prensagem=local_prensagem,
            )
            redirect('/acervo?msg=cadastrado')

        redirect('/acervo?msg=erro')

    def pagina_editar(self, midia_id: int):
        usuario = self._exigir_login()
        midia = self.repositorio.buscar_por_id(midia_id)
        if not midia:
            redirect('/acervo?msg=nao_encontrado')
        return template('app/views/html/editar', usuario=usuario, midia=midia)

    def atualizar_midia(self, midia_id: int):
        self._exigir_login()
        formato = request.forms.getunicode('formato', 'Vinil')
        titulo = request.forms.getunicode('titulo', '').strip()
        nome_artista = request.forms.getunicode('artista', '').strip()
        pais_origem = request.forms.getunicode('pais_origem', '').strip()
        ano_lancamento = request.forms.getunicode('ano_lancamento', '').strip()
        estado_conservacao = request.forms.getunicode('estado_conservacao', 'Excelente')
        data_prensagem = request.forms.getunicode('data_prensagem', '').strip()
        local_prensagem = request.forms.getunicode('local_prensagem', '').strip()

        try:
            valor = float(request.forms.get('valor', '0').replace(',', '.'))
        except ValueError:
            valor = 0.0

        if titulo and nome_artista and ano_lancamento:
            self.repositorio.atualizar_midia(
                midia_id=midia_id,
                formato=formato,
                titulo=titulo,
                nome_artista=nome_artista,
                pais_origem=pais_origem,
                ano_lancamento=ano_lancamento,
                estado_conservacao=estado_conservacao,
                valor=valor,
                data_prensagem=data_prensagem,
                local_prensagem=local_prensagem,
            )
            redirect('/acervo?msg=atualizado')

        redirect(f'/midias/editar/{midia_id}')

    def excluir_midia(self, midia_id: int):
        self._exigir_login()
        self.repositorio.remover_midia(midia_id)
        redirect('/acervo?msg=excluido')

    def helper(self):
        return template('app/views/html/helper')