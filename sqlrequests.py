import pymysql.cursors
import configparser
from cryptography.fernet import Fernet
import re
import subprocess


# Função para estabelecer a conexão com o banco de dados
# Função para estabelecer a conexão com o banco de dados
def conectar_bd():
    # Ler as configurações do arquivo config.ini
    config = configparser.ConfigParser()
    config.read('/home/formando/Desktop/src/Projeto_Final/config.ini')

    # Extrair as configurações do banco de dados do arquivo config.ini
    db_config = config['database']

    # Conectar ao banco de dados
    conexao = pymysql.connect(
        host=db_config['host'],
        user=db_config['user'],
        password=db_config['password'],
        database=db_config['database']
    )
    return conexao


def login():
    # Obter entrada do usuário para nome de usuário e senha
    email = input("Digite o email de Operador: ")
    password = input("Digite a password: ")

    # Validar credenciais do usuário
    conexao = conectar_bd()
    try:
        with conexao.cursor() as cursor:
            sql = "SELECT * FROM Operator WHERE email=%s AND password=%s"
            cursor.execute(sql, (email, password))
            resultado = cursor.fetchone()
            if resultado:
                print("Login bem-sucedido!")
                return resultado
            else:
                print("Nome de usuário ou senha inválidos.")
                return None
    finally:
        conexao.close()

def pesquisar_usuario():
    # Obter entrada do usuário para ID do usuário ou email do utilizador
    idoremail = input("Digite o ID do usuário ou email do utilizador: ")
    
    # Conectar ao banco de dados
    conexao = conectar_bd()
    
    try:
        with conexao.cursor() as cursor:
            sql = "SELECT * FROM Client WHERE id=%s OR email=%s"
            cursor.execute(sql, (idoremail, idoremail))
            resultado = cursor.fetchall()

            if resultado:
                print("Usuários encontrados:")
                # Lista para armazenar larguras das colunas
                larguras = [max(len(str(field)) for field in row) for row in zip(*resultado)]
                
                # Obter nomes das colunas
                nomes_colunas = [column[0] for column in cursor.description]
                
                # Imprimir cabeçalho da tabela
                print("+" + "+".join("-" * (largura + 2) for largura in larguras) + "+")
                print("|" + "|".join(f" {campo:{largura}} " for campo, largura in zip(nomes_colunas, larguras)) + "|")
                print("+" + "+".join("-" * (largura + 2) for largura in larguras) + "+")
                
                # Imprimir linhas de dados
                for row in resultado:
                    print("|" + "|".join(f" {str(valor):{largura}} " for valor, largura in zip(row, larguras)) + "|")
                    print("+" + "+".join("-" * (largura + 2) for largura in larguras) + "+")
                
                acao = input("Você deseja (b)loquear ou (d)esbloquear estes usuários? ")
                if acao.lower() == 'b':
                    # Bloquear conta do usuário
                    # Implementar lógica de bloqueio aqui
                    print("Contas dos usuários bloqueadas com sucesso.")
                elif acao.lower() == 'd':
                    # Desbloquear conta do usuário
                    # Implementar lógica de desbloqueio aqui
                    print("Contas dos usuários desbloqueadas com sucesso.")
                else:
                    print("Opção inválida.")
            else:
                print("Nenhum usuário encontrado.")
    finally:
        conexao.close()

def listar_produtos():
    # Conectar ao banco de dados
    conexao = conectar_bd()
    try:
        with conexao.cursor() as cursor:
            # Listar produtos com filtros opcionais
            tipo_produto = input("Digite o tipo de produto (Book ou Electronic) ou deixe em branco para todos: ")
            quantidade_min = input("Digite a quantidade mínima ou deixe em branco para todos: ")
            quantidade_max = input("Digite a quantidade máxima ou deixe em branco para todos: ")
            preco_min = input("Digite o preço mínimo ou deixe em branco para todos: ")
            preco_max = input("Digite o preço máximo ou deixe em branco para todos: ")

            sql = "SELECT * FROM Product WHERE 1=1"


            params = []


            if quantidade_min:
                sql += " AND quantity >= %s"
                params.append(quantidade_min)
            if quantidade_max:
                sql += " AND quantity <= %s"
                params.append(quantidade_max)
            if preco_min:
                sql += " AND price >= %s"
                params.append(preco_min)
            if preco_max:
                sql += " AND price <= %s"
                params.append(preco_max)

            cursor.execute(sql, tuple(params))
            resultado = cursor.fetchall()
            if resultado:
                print("Produtos encontrados:")
                for linha in resultado:
                    print(linha)
            else:
                print("Nenhum produto encontrado com os critérios fornecidos.")
    finally:
        conexao.close()


def executar_backup():
    # Nome do arquivo de backup
    config = configparser.ConfigParser()
    config.read('/home/formando/Desktop/src/Projeto_Final/config.ini')

    # Extrair as configurações do banco de dados do arquivo config.ini
    db_config = config['database']
    
    nome_arquivo = input("Digite o nome do arquivo de backup: ")

    # Comando mysqldump para fazer o backup
    comando = f"mysqldump -u {db_config['user']} -p{db_config['password']} {db_config['database']} > {nome_arquivo}.sql"

    try:
        # Executar o comando de backup
        subprocess.run(comando, shell=True, check=True)
        print("Backup concluído com sucesso!")
    except subprocess.CalledProcessError as e:
        print(f"Erro ao executar o backup: {e}")


def menu_principal(utilizador):
    # Loop até que o usuário escolha sair
    while True:
        print("1. Pesquisar Utilizador")
        print("2. Listar Produtos")
        print("3. Registar Produtos")
        print("4. Backup")
        print("5. Sair")

        escolha = input("Escolha uma opção (1, 2,3,4 ou 5): ")

        if re.match(r'1', escolha):
            pesquisar_usuario()
        elif re.match(r'2', escolha):
                listar_produtos()
        elif re.match(r'3', escolha):
                print("em obras")
        elif re.match(r'4', escolha):
            executar_backup()
        elif re.match(r'5', escolha):
            print("Saindo...")
            return
        else:
            print("Escolha inválida. Por favor, tente novamente.")







# Função principal
if __name__ == "__main__":
    # Login
    utilizador = login()
    if utilizador:
        menu_principal(utilizador)
