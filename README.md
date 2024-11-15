# README

## Diagrama de Entidade-Relacionamento (ERD)

Você pode acessar o diagrama ERD pelo link abaixo:
- [Diagrama ERD no DrawSQL](https://drawsql.app/teams/just-me-110/diagrams/paleva)

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
- `status` (opcional): Filtra os pedidos pelo status especificado.

- **Endpoint**: `GET /api/v1/orders/id`
- `id` (obrigatório): Mostra um único pedido pelo id especificado.
