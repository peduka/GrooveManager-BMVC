from abc import ABC, abstractmethod
import os
import sqlite3


class Artista:
    def __init__(self, nome: str, pais_origem: str, artista_id: int | None = None):
        self.id = artista_id
        self.nome = nome.strip()
        self.pais_origem = pais_origem.strip()


class RegistroCompra:
    def __init__(
        self,
        valor: float,
        data_prensagem: str,
        local_prensagem: str,
        registro_id: int | None = None,
    ):
        self.id = registro_id
        self.valor = float(valor)
        self.data_prensagem = data_prensagem.strip()
        self.local_prensagem = local_prensagem.strip()


class Midia(ABC):
    def __init__(
        self,
        titulo: str,
        ano_lancamento: str,
        estado_conservacao: str,
        artista: Artista,
        registro_compra: RegistroCompra,
        midia_id: int | None = None,
    ):
        self.id = midia_id
        self.titulo = titulo.strip()
        self.ano_lancamento = str(ano_lancamento).strip()
        self.estado_conservacao = estado_conservacao.strip()
        self.artista = artista
        self.registro_compra = registro_compra

    @property
    @abstractmethod
    def formato(self) -> str:
        pass

    @abstractmethod
    def detalhe_formato(self) -> str:
        pass


class Vinil(Midia):
    @property
    def formato(self) -> str:
        return "Vinil"

    def detalhe_formato(self) -> str:
        return "LP Analógico (33/45 RPM)"


class CD(Midia):
    @property
    def formato(self) -> str:
        return "CD"

    def detalhe_formato(self) -> str:
        return "Compact Disc Digital (16-bit / 44.1 kHz)"


class K7(Midia):
    @property
    def formato(self) -> str:
        return "K7"

    def detalhe_formato(self) -> str:
        return "Fita Magnética Cassete"


class AcervoRepositorio:
    """Gerencia a persistência SQLite e instancia os objetos do domínio GrooveManager."""

    CLASSES_FORMATO = {
        "Vinil": Vinil,
        "CD": CD,
        "K7": K7,
    }

    def __init__(self, db_path: str = "app/controllers/db/groovemanager.db"):
        os.makedirs(os.path.dirname(db_path), exist_ok=True)
        self.db_path = db_path
        self._criar_tabelas()
        self._popular_dados_iniciais()

    def _conectar(self) -> sqlite3.Connection:
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row
        conn.execute("PRAGMA foreign_keys = ON;")
        return conn

    def _criar_tabelas(self):
        with self._conectar() as conn:
            conn.executescript(
                """
                CREATE TABLE IF NOT EXISTS artistas (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    nome TEXT NOT NULL UNIQUE,
                    pais_origem TEXT NOT NULL
                );

                CREATE TABLE IF NOT EXISTS midias (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    formato TEXT NOT NULL,
                    titulo TEXT NOT NULL,
                    ano_lancamento TEXT NOT NULL,
                    estado_conservacao TEXT NOT NULL,
                    artista_id INTEGER NOT NULL,
                    FOREIGN KEY (artista_id) REFERENCES artistas(id)
                );

                CREATE TABLE IF NOT EXISTS registros_compra (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    midia_id INTEGER NOT NULL UNIQUE,
                    valor REAL NOT NULL,
                    data_prensagem TEXT NOT NULL,
                    local_prensagem TEXT NOT NULL,
                    FOREIGN KEY (midia_id) REFERENCES midias(id) ON DELETE CASCADE
                );
                """
            )

    def _popular_dados_iniciais(self):
        with self._conectar() as conn:
            total = conn.execute("SELECT COUNT(*) FROM midias").fetchone()[0]
            if total > 0:
                return

        exemplos = [
            ("Vinil", "Doolittle", "Pixies", "EUA", "1989", "Excelente", 180.00, "1990", "Inglaterra"),
            ("CD", "Surfer Rosa", "Pixies", "EUA", "1988", "Bom", 100.00, "2001", "EUA"),
            ("Vinil", "Tim Maia", "Tim Maia", "Brasil", "1970", "Bom", 250.00, "1970", "Brasil"),
            ("K7", "The Dark Side of the Moon", "Pink Floyd", "Inglaterra", "1973", "Excelente", 60.00, "1973", "Inglaterra"),
        ]
        for item in exemplos:
            self.adicionar_midia(*item)

    def _montar_objeto(self, row: sqlite3.Row) -> Midia:
        artista = Artista(
            nome=row["artista_nome"],
            pais_origem=row["pais_origem"],
            artista_id=row["artista_id"],
        )
        compra = RegistroCompra(
            valor=row["valor"],
            data_prensagem=row["data_prensagem"],
            local_prensagem=row["local_prensagem"],
            registro_id=row["registro_id"],
        )
        classe_midia = self.CLASSES_FORMATO.get(row["formato"], Vinil)
        return classe_midia(
            titulo=row["titulo"],
            ano_lancamento=row["ano_lancamento"],
            estado_conservacao=row["estado_conservacao"],
            artista=artista,
            registro_compra=compra,
            midia_id=row["id"],
        )

    def listar_midias(self) -> list[Midia]:
        query = """
            SELECT
                m.id, m.formato, m.titulo, m.ano_lancamento, m.estado_conservacao,
                a.id AS artista_id, a.nome AS artista_nome, a.pais_origem,
                r.id AS registro_id, r.valor, r.data_prensagem, r.local_prensagem
            FROM midias m
            JOIN artistas a ON m.artista_id = a.id
            JOIN registros_compra r ON r.midia_id = m.id
            ORDER BY m.id DESC
        """
        with self._conectar() as conn:
            rows = conn.execute(query).fetchall()
        return [self._montar_objeto(r) for r in rows]

    def buscar_por_id(self, midia_id: int) -> Midia | None:
        query = """
            SELECT
                m.id, m.formato, m.titulo, m.ano_lancamento, m.estado_conservacao,
                a.id AS artista_id, a.nome AS artista_nome, a.pais_origem,
                r.id AS registro_id, r.valor, r.data_prensagem, r.local_prensagem
            FROM midias m
            JOIN artistas a ON m.artista_id = a.id
            JOIN registros_compra r ON r.midia_id = m.id
            WHERE m.id = ?
        """
        with self._conectar() as conn:
            row = conn.execute(query, (midia_id,)).fetchone()
        return self._montar_objeto(row) if row else None

    def adicionar_midia(
        self,
        formato: str,
        titulo: str,
        nome_artista: str,
        pais_origem: str,
        ano_lancamento: str,
        estado_conservacao: str,
        valor: float,
        data_prensagem: str,
        local_prensagem: str,
    ) -> Midia:
        formato = formato if formato in self.CLASSES_FORMATO else "Vinil"
        nome_artista = nome_artista.strip()
        pais_origem = pais_origem.strip() or "Não informado"

        with self._conectar() as conn:
            row_art = conn.execute(
                "SELECT id FROM artistas WHERE LOWER(nome) = LOWER(?)",
                (nome_artista,),
            ).fetchone()

            if row_art:
                artista_id = row_art["id"]
            else:
                cur_art = conn.execute(
                    "INSERT INTO artistas (nome, pais_origem) VALUES (?, ?)",
                    (nome_artista, pais_origem),
                )
                artista_id = cur_art.lastrowid

            cur_midia = conn.execute(
                """
                INSERT INTO midias (formato, titulo, ano_lancamento, estado_conservacao, artista_id)
                VALUES (?, ?, ?, ?, ?)
                """,
                (
                    formato,
                    titulo.strip(),
                    str(ano_lancamento).strip(),
                    estado_conservacao.strip(),
                    artista_id,
                ),
            )
            midia_id = cur_midia.lastrowid

            conn.execute(
                """
                INSERT INTO registros_compra (midia_id, valor, data_prensagem, local_prensagem)
                VALUES (?, ?, ?, ?)
                """,
                (
                    midia_id,
                    float(valor),
                    data_prensagem.strip() or str(ano_lancamento).strip(),
                    local_prensagem.strip() or pais_origem,
                ),
            )

        return self.buscar_por_id(midia_id)

    def atualizar_midia(
        self,
        midia_id: int,
        formato: str,
        titulo: str,
        nome_artista: str,
        pais_origem: str,
        ano_lancamento: str,
        estado_conservacao: str,
        valor: float,
        data_prensagem: str,
        local_prensagem: str,
    ) -> bool:
        formato = formato if formato in self.CLASSES_FORMATO else "Vinil"
        with self._conectar() as conn:
            row = conn.execute("SELECT artista_id FROM midias WHERE id = ?", (midia_id,)).fetchone()
            if not row:
                return False

            conn.execute(
                "UPDATE artistas SET nome = ?, pais_origem = ? WHERE id = ?",
                (nome_artista.strip(), pais_origem.strip(), row["artista_id"]),
            )
            conn.execute(
                """
                UPDATE midias
                SET formato = ?, titulo = ?, ano_lancamento = ?, estado_conservacao = ?
                WHERE id = ?
                """,
                (
                    formato,
                    titulo.strip(),
                    str(ano_lancamento).strip(),
                    estado_conservacao.strip(),
                    midia_id,
                ),
            )
            conn.execute(
                """
                UPDATE registros_compra
                SET valor = ?, data_prensagem = ?, local_prensagem = ?
                WHERE midia_id = ?
                """,
                (
                    float(valor),
                    data_prensagem.strip(),
                    local_prensagem.strip(),
                    midia_id,
                ),
            )
        return True

    def remover_midia(self, midia_id: int) -> bool:
        with self._conectar() as conn:
            cur = conn.execute("DELETE FROM midias WHERE id = ?", (midia_id,))
            return cur.rowcount > 0