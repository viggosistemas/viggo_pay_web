## 1.0.1+1

* Projeto inicial

## 1.0.1+1

* Colocando para filtrar por parentId quando for acessado via menu de suporte
* Correção no salvar user dar reload e colocando displayName no autocomplete de domains
* Colocando no ls os papeis do usuario logado para validações e permitindo logar com o EnterKey
* Colocando função recursiva que monta as tuplas das tabelas
* Criando menu de domínios por matriz para usuarios suporte
* viggo-core - v1.0.7

## 1.0.2+1

* Correção no componente de TablePaginated para não exibir mensagem vazia por enquanto

## 1.0.3+1

* Correção na seleção de tuplas do dialog de add capacidades ou políticas

* Adicionando filtragem por tag 'MATRIZ' para menu de matriz por domínio

* Adicionado uma validação para ao criar um novo usuário pelo SYSADMIN ou SUPORTE seja obrigatório selecionar um papel

* Colocado para qualquer usuário que não seja SYSADMIN não possa selecionar o papel SYSADMIN mesmo que o papel venha na listagem de papéis disponíveis

* O problema relatado consistia na quebra de contexto entre a interface principal de listagem e o dialog de edição/criação do usuário independente do tipo de usuário poderia acontecer a quebra

* Foi adicionado uma validação para caso usuários SUPORTE queiram editar o SYSADMIN seja bloqueado e também só consigam criar usuários de outros papéis sem ser SYSADMIN

* Adicionando uma validação para repassar o domínio selecionado no menu de usuários por domínio para puxar os papéis corretamente

## [PRÓXIMA VERSÃO] - yyyy-mm-dd

### Adicionado

### Modificado

### Corrigido

- [#EM-4167](https://viggosistemas.atlassian.net/browse/EM-4167) Mapeia papéis que o usuário já possui para evitar replicar grants

### Removido