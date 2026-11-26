from bottle import redirect, request, template
from app.models.midia import AcervoRepositorio


class Application:

    def __init__(self):
        self.repositorio = AcervoRepositorio()
        self.pages = {
            'index': self.index,
            'helper': self.helper,
        }

    def render(self, page):
        content = self.pages.get(page, self.index)
        return content()

    def index(self):
        midias = self.repositorio.listar_midias()
        valor_total = sum(m.registro_compra.valor for m in midias)
        aviso = request.query.get('msg', '')
        return template(
            'app/views/html/index',
            midias=midias,
            valor_total=valor_total,
            aviso=aviso,
        )

    def criar_midia(self):
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
            redirect('/?msg=cadastrado')

        redirect('/?msg=erro')

    def pagina_editar(self, midia_id: int):
        midia = self.repositorio.buscar_por_id(midia_id)
        if not midia:
            redirect('/?msg=nao_encontrado')
        return template('app/views/html/editar', midia=midia)

    def atualizar_midia(self, midia_id: int):
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
            redirect('/?msg=atualizado')

        redirect(f'/midias/editar/{midia_id}')

    def excluir_midia(self, midia_id: int):
        self.repositorio.remover_midia(midia_id)
        redirect('/?msg=excluido')

    def helper(self):
        return template('app/views/html/helper')