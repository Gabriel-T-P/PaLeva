# PaLevá 

Você pode acessar o diagrama Entidade-Relacionamento pelo link abaixo:
- [Diagrama ERD](https://drawsql.app/teams/just-me-110/diagrams/paleva)

---

## Gems utilizadas:
- bootstrap
- cpf_cnpj
- rack-cors
- devise
- capybara


## Cadastro criado pelo Seeds

### Admin
- **E-mail**: `master@email.com`
- **Senha**: `12345678`

### Employee
- **E-mail**: `employee@email.com`
- **Senha**: `12345678`


## Endpoints da API

- **Endpoint**: `GET /api/v1/orders?status=value`
`status` (opcional): Mostra todos os pedidos ou filtra por um status especificado.

- **Endpoint**: `GET /api/v1/orders/:id`
`id` (obrigatório): Mostra um único pedido pelo id especificado.

- **Endpoint**: `PATCH /api/v1/orders/:id/set_status_cooking`
`id` (obrigatório): Atualiza pedido para em preparo.

- **Endpoint**: `PATCH /api/v1/orders/:id/set_status_ready`
`id` (obrigatório): Atualiza pedido para pronto.

- **Endpoint**: `PATCH /api/v1/:establishment_code/:order_code/orders/:id/set_status_canceled`
`order_code` (obrigatório): Atualiza pedido para cancelado.


## Bugs Atuais:

Infelizmente eu não consegui resolver a tempo um problema com o cadastro do funcionário. É possível ver
pelos testes no rspec que existem 3 testes falhando, referentes a esse problema. O problema está muito provavelmente
relacionado ao tipo de relação que eu usei entre o user, establishment e employee.