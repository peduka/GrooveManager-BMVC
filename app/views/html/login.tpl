<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acesso Restrito — GrooveManager Web</title>
    <link rel="stylesheet" href="/static/css/groovemanager.css">
</head>
<body>
    <header class="topbar">
        <div class="container topbar-content">
            <div class="brand">
                <span class="brand-badge">BMVC III • CONTROLE DE ACESSO</span>
                <h1>GrooveManager</h1>
                <p>Autenticação para gerenciamento do acervo</p>
            </div>
            <nav class="nav-links">
                <a href="/">← Voltar à Vitrine Pública</a>
            </nav>
        </div>
    </header>

    <main class="container auth-container">
        % if aviso == 'acesso_restrito':
        <div class="alert alert-danger">Acesso restrito! Faça login para entrar na área de gerenciamento do acervo.</div>
        % elif aviso == 'credenciais_invalidas':
        <div class="alert alert-danger">Usuário ou senha incorretos. Tente novamente.</div>
        % elif aviso == 'erro_cadastro':
        <div class="alert alert-danger">Não foi possível cadastrar: verifique se o usuário já existe ou se a senha tem ao menos 4 caracteres.</div>
        % elif aviso == 'saiu':
        <div class="alert alert-warning">Sessão encerrada com segurança.</div>
        % end

        <section class="card auth-card">
            <div class="auth-tabs">
                <button type="button" class="btn-auth-tab active" data-tab="form-login">Entrar (Login)</button>
                <button type="button" class="btn-auth-tab" data-tab="form-registro">Criar Nova Conta</button>
            </div>

            <!-- Formulário de Login -->
            <form id="form-login" action="/login" method="post" class="auth-form">
                <h2>Acesso ao Painel do Colecionador</h2>
                <p class="subtitle">Entre com seu usuário para liberar cadastro, edição e exclusão de mídias.</p>

                <div class="demo-credentials">
                    <strong>Conta de demonstração pronta:</strong><br>
                    Usuário: <code>colecionador</code> &nbsp;|&nbsp; Senha: <code>1234</code>
                </div>

                <div class="form-group" style="margin-bottom: 14px;">
                    <label for="login-username">Usuário</label>
                    <input type="text" id="login-username" name="username" placeholder="Digite seu usuário" required>
                </div>

                <div class="form-group" style="margin-bottom: 18px;">
                    <label for="login-senha">Senha</label>
                    <div class="password-wrapper">
                        <input type="password" id="login-senha" name="senha" placeholder="Digite sua senha" required>
                        <button type="button" class="btn-toggle-pass" data-target="login-senha">Mostrar</button>
                    </div>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%;">Entrar na Área Restrita</button>
            </form>

            <!-- Formulário de Cadastro de Novo Usuário -->
            <form id="form-registro" action="/cadastro" method="post" class="auth-form hidden">
                <h2>Cadastrar Novo Colecionador</h2>
                <p class="subtitle">Cria um novo objeto <code>Usuario</code> no SQLite e inicia sessão automaticamente.</p>

                <div class="form-group" style="margin-bottom: 14px;">
                    <label for="reg-nome">Nome Completo *</label>
                    <input type="text" id="reg-nome" name="nome" placeholder="Ex.: Pedro Alexandre" required>
                </div>

                <div class="form-group" style="margin-bottom: 14px;">
                    <label for="reg-username">Nome de Usuário (Login) *</label>
                    <input type="text" id="reg-username" name="username" placeholder="Ex.: pedro" required>
                </div>

                <div class="form-group" style="margin-bottom: 18px;">
                    <label for="reg-senha">Senha (mínimo 4 caracteres) *</label>
                    <div class="password-wrapper">
                        <input type="password" id="reg-senha" name="senha" minlength="4" placeholder="Crie uma senha" required>
                        <button type="button" class="btn-toggle-pass" data-target="reg-senha">Mostrar</button>
                    </div>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%;">Criar Conta e Acessar</button>
            </form>
        </section>
    </main>

    <footer class="footer">
        <div class="container">
            <p>GrooveManager • Controle de Acesso BMVC III</p>
        </div>
    </footer>

    <script src="/static/js/groovemanager.js"></script>
</body>
</html>