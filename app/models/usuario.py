import hashlib
import os
import sqlite3


class Usuario:
    def __init__(self, nome: str, username: str, usuario_id: int | None = None):
        self.id = usuario_id
        self.nome = nome.strip()
        self.username = username.strip().lower()


class UsuarioRepositorio:
    """Gerencia autenticação e persistência de usuários no SQLite."""

    def __init__(self, db_path: str = "app/controllers/db/groovemanager.db"):
        os.makedirs(os.path.dirname(db_path), exist_ok=True)
        self.db_path = db_path
        self._criar_tabela()
        self._criar_usuario_padrao()

    def _conectar(self) -> sqlite3.Connection:
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row
        return conn

    @staticmethod
    def _hash_senha(senha: str) -> str:
        return hashlib.sha256(senha.encode("utf-8")).hexdigest()

    def _criar_tabela(self):
        with self._conectar() as conn:
            conn.execute(
                """
                CREATE TABLE IF NOT EXISTS usuarios (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    nome TEXT NOT NULL,
                    username TEXT NOT NULL UNIQUE,
                    senha_hash TEXT NOT NULL
                );
                """
            )

    def _criar_usuario_padrao(self):
        with self._conectar() as conn:
            existe = conn.execute("SELECT COUNT(*) FROM usuarios").fetchone()[0]
            if existe == 0:
                conn.execute(
                    "INSERT INTO usuarios (nome, username, senha_hash) VALUES (?, ?, ?)",
                    ("Pedro Colecionador", "colecionador", self._hash_senha("1234")),
                )

    def autenticar(self, username: str, senha: str) -> Usuario | None:
        senha_hash = self._hash_senha(senha)
        with self._conectar() as conn:
            row = conn.execute(
                "SELECT id, nome, username FROM usuarios WHERE LOWER(username) = LOWER(?) AND senha_hash = ?",
                (username.strip(), senha_hash),
            ).fetchone()
        if not row:
            return None
        return Usuario(nome=row["nome"], username=row["username"], usuario_id=row["id"])

    def cadastrar(self, nome: str, username: str, senha: str) -> Usuario | None:
        username_limpo = username.strip().lower()
        if not nome.strip() or not username_limpo or len(senha) < 4:
            return None
        try:
            with self._conectar() as conn:
                cur = conn.execute(
                    "INSERT INTO usuarios (nome, username, senha_hash) VALUES (?, ?, ?)",
                    (nome.strip(), username_limpo, self._hash_senha(senha)),
                )
                return Usuario(nome=nome, username=username_limpo, usuario_id=cur.lastrowid)
        except sqlite3.IntegrityError:
            return None

    def buscar_por_id(self, usuario_id: int) -> Usuario | None:
        with self._conectar() as conn:
            row = conn.execute(
                "SELECT id, nome, username FROM usuarios WHERE id = ?",
                (usuario_id,),
            ).fetchone()
        if not row:
            return None
        return Usuario(nome=row["nome"], username=row["username"], usuario_id=row["id"])