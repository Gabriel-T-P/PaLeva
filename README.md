# README

Você pode acessar o diagrama Entidade-Relacionamento pelo link abaixo:
- [Diagrama ERD](https://drawsql.app/teams/just-me-110/diagrams/paleva)

---

## Cadastro criado pelo Seed

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