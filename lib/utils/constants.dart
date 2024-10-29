//ignore_for_file: constant_identifier_names

// CLASSE DE ROTAS QUE DECLARAM TODAS AS ROTAS DO PROJETO
class Routes {
  static const HOME = '/';
  static const LOGIN_PAGE = '/login';
  static const FORGET_PASSWORD = '/forget_password';
  static const WORKSPACE = '/workspace';
  //admin
  static const MATRIZ = '/matriz_perfil';
  static const DOMAIN_ACCOUNTS = '/empresas';
  static const PIX = '/pix';
  static const EXTRATO = '/extrato';
  static const MATRIZ_TRANSFERENCIA = '/matriz_transferencia';
  static const FUNCIONARIO = '/funcionarios';
  //sysadmin
  static const USERS = '/users';
  static const DOMAINS = '/domains';
  static const APPLICATIONS = '/applications';
  static const ROUTES = '/routes';
  static const ROLES = '/roles';
  static const USERS_FOR_DOMAIN = '/usuarios_por_dominio';
  static const MATRIZ_DOMAIN = '/dominios_por_matriz';
  static const EDIT_CAPABILITY = '/editar_capacidades';
  static const EDIT_POLICY = '/editar_politica';
}

// CLASSE DE CONTANTS QUE DECLARAM TODAS AS VARIAVEIS COMUMENTE USADAS NO PROJETO
class Constants {
  static const APP_NAME = 'ViggoPay Admin';
}

class AppStateConst {
  static const LOGGED = 'LOGGED';
  static const NOT_LOGGED = 'NOT_LOGGED';
  static const ACTIVE = 'ACTIVE';
}
