<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Mídia — GrooveManager Web</title>
    <link rel="stylesheet" href="/static/css/groovemanager.css">
</head>
<body>
    <header class="topbar">
        <div class="container topbar-content">
            <div class="brand">
                <span class="brand-badge">BMVC III • EDIÇÃO RESTRITA</span>
                <h1>GrooveManager</h1>
                <p>Atualização de registro no acervo</p>
            </div>
            <nav class="nav-links">
                <span class="user-pill">Usuário: <strong>{{ usuario.username }}</strong></span>
                <a href="/acervo">← Voltar à Área Restrita</a>
                <a href="/logout" class="nav-logout">Sair</a>
            </nav>
        </div>
    </header>

    <main class="container">
        <section class="card">
            <h2>Editar: {{ midia.titulo }}</h2>
            <p class="subtitle">Altere os atributos do objeto <code>{{ midia.formato }}</code> (ID #{{ midia.id }}) e salve no banco SQLite.</p>

            <form action="/midias/editar/{{ midia.id }}" method="post" class="crud-form">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="formato">Formato *</label>
                        <select id="formato" name="formato" required>
                            <option value="Vinil" {{ 'selected' if midia.formato == 'Vinil' else '' }}>Vinil</option>
                            <option value="CD" {{ 'selected' if midia.formato == 'CD' else '' }}>CD</option>
                            <option value="K7" {{ 'selected' if midia.formato == 'K7' else '' }}>K7</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="titulo">Título do Álbum *</label>
                        <input type="text" id="titulo" name="titulo" value="{{ midia.titulo }}" required>
                    </div>

                    <div class="form-group">
                        <label for="artista">Artista / Banda *</label>
                        <input type="text" id="artista" name="artista" value="{{ midia.artista.nome }}" required>
                    </div>

                    <div class="form-group">
                        <label for="pais_origem">País de Origem *</label>
                        <input type="text" id="pais_origem" name="pais_origem" value="{{ midia.artista.pais_origem }}" required>
                    </div>

                    <div class="form-group">
                        <label for="ano_lancamento">Ano Lançamento *</label>
                        <input type="number" id="ano_lancamento" name="ano_lancamento" min="1900" max="2026" value="{{ midia.ano_lancamento }}" required>
                    </div>

                    <div class="form-group">
                        <label for="estado_conservacao">Conservação *</label>
                        <select id="estado_conservacao" name="estado_conservacao" required>
                            <option value="Lacrado" {{ 'selected' if midia.estado_conservacao == 'Lacrado' else '' }}>Lacrado</option>
                            <option value="Excelente" {{ 'selected' if midia.estado_conservacao == 'Excelente' else '' }}>Excelente</option>
                            <option value="Bom" {{ 'selected' if midia.estado_conservacao == 'Bom' else '' }}>Bom</option>
                            <option value="Ruim" {{ 'selected' if midia.estado_conservacao == 'Ruim' else '' }}>Ruim</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="valor">Valor Pago (R$) *</label>
                        <input type="number" id="valor" name="valor" step="0.01" min="0" value="{{ f'{midia.registro_compra.valor:.2f}' }}" required>
                    </div>

                    <div class="form-group">
                        <label for="data_prensagem">Data / Ano Prensagem</label>
                        <input type="text" id="data_prensagem" name="data_prensagem" value="{{ midia.registro_compra.data_prensagem }}">
                    </div>

                    <div class="form-group">
                        <label for="local_prensagem">Local de Prensagem</label>
                        <input type="text" id="local_prensagem" name="local_prensagem" value="{{ midia.registro_compra.local_prensagem }}">
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">Salvar Alterações</button>
                    <a href="/acervo" class="btn-secondary" style="text-decoration: none;">Cancelar</a>
                </div>
            </form>
        </section>
    </main>

    <script src="/static/js/groovemanager.js"></script>
</body>
</html>