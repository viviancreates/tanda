# Tanda

## Description
The Tanda App is a Ruby on Rails application that allows users to set savings goals and track them collaboratively with friends and family, promoting financial accountability and transparency within groups, powered by cryptocurrency wallets.

## PM To Do List and Board
[Project Management Board](https://daily-glider-ca4.notion.site/TANDA-Project-Board-15689123f3bb80b5a8d7d169d15d795e?pvs=4)

## Table of Contents
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Contributing](#contributing)
- [Visual Aids](#visual-aids)
- [API Implementation](#api-implementation)
- [End To End Testing](#end-to-end-testing)
- [Troubleshooting](#troubleshooting)
- [Notes](#notes)
- [License](#license)
- [Contact](#contact)

## Installation
1. Clone the repository:
`git clone https://github.com/viviancreates/tanda`

2. Navigate to the project directory:
`cd tanda`

3. Install the required gems:
`bundle install`

4. Set up the database:
`rails db:setup`

5. Start the Rails server:
`rails server`

6. Open your browser and navigate to:
`http://localhost:3000`

## Configuration
### Environment Variables
Ensure the following environment variables are set up in a `.env` file or in your deployment environment:
`API_KEY_NAME=<Your API Key Name> `
`API_KEY_PRIVATE_KEY=<Your API Private Key>`


### Database Configuration
1. Verify and update `config/database.yml` with the correct database credentials if necessary.
2. Run the following commands to set up the database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed or rake sample_data

## Usage

1. Start the Rails server:
`rails server`

2. Open your browser and navigate to http://localhost:3000
Follow the on-screen instructions to use the application

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature-branch`)
5. Open a pull request

## Visual Aids
### ERD

![erd](https://github.com/user-attachments/assets/7f4b5289-e2ef-41be-8eec-0f7898442a16)



## API Implementation
This project integrates with the Coinbase API to provide wallet creation, funding, and cryptocurrency transfers. These functionalities ensure secure and efficient cryptocurrency transaction handling. 

### Authentication
To use the API, ensure the following environment variables are set:
- `API_KEY_NAME`
- `API_KEY_PRIVATE_KEY`

### Endpoints
### Create Wallet
- **Description:** Creates a wallet for the user.
- **Method:** `POST`
- **Endpoint:** `/users/:id/create_wallet`
- **Request Body:** None
- **Response:**
  ```json
  {
    "status": "success",
    "wallet_id": "mock_wallet_id",
    "balance": 0
  }
### Fund Wallet
- **Description:** Adds testnet funds to the user's wallet.
- **Method:** `POST`
- **Endpoint:** `/users/:id/fund_wallet`
- **Request Body:** None
- **Response:**
  ```json
  {
    "status": "success",
    "transaction_hash": "<transaction_hash>",
    "transaction_link": "<transaction_link>",
    "balance": "<new_balance>"
  }
### Transfer Funds
- **Description:** Transfers cryptocurrency to a recipient's wallet.
- **Method:** `POST`
- **Endpoint:** `/users/:id/transfer`
- **Request Body:**
  ```json
  {
    "amount": "<amount>",
    "currency": "eth",
    "recipient_address": "<recipient_address>",
    "tanda_id": "<tanda_id>"
  }
  ```
- **Response Body:**
  ```json
  {
    "status": "success",
    "transaction_link": "<transaction_link>",
    "updated_balance": "<updated_balance>"
  }

## End-to-End Testing
This project includes end-to-end tests to validate key workflows and ensure robust application functionality. The tests are implemented using `Minitest` and are designed to simulate real-world usage scenarios.

### Coinbase Wallet Functionality Tests
- **Create Wallet**: Ensures a new wallet is successfully created and associated with the user.
- **Fund Wallet**: Validates the wallet funding process via a testnet faucet, ensuring the user's balance updates correctly.
- **Transfer Funds**: Tests transferring funds to another wallet address, verifying balance updates and transaction success.

### Tanda Application Workflow Tests
- **Profile and Friend Management**: Confirms a user profile can be created and friend requests can be sent and accepted.
- **Tanda Creation and Participation**: Ensures users can create a Tanda with a defined goal amount and due date, and validates the addition of participants.
- **Transaction Management**: Tests adding transactions to a Tanda, ensuring amounts, descriptions, and transaction types are recorded accurately.

### Test Details
- The Coinbase functionality tests are implemented in `test/controllers/coinbase_api_test.rb`.
- The Tanda application flow tests are implemented in `test/controllers/tanda_flow_test.rb`.

### How to Run the Tests
To execute the test suite, run the following command:
rails test

## Troubleshooting
### Common Issues
1. **Database Setup Issues:**
   Ensure your PostgreSQL service is running and credentials are correctly configured in `config/database.yml`.

2. **Missing API Keys:**
   Verify that `API_KEY_NAME` and `API_KEY_PRIVATE_KEY` are set in the environment.

3. **Server Not Starting:**
   Run `rails db:migrate` to ensure the database schema is up-to-date.

## Notes
- Transfers show up on the transactions, converted to USD! :D Will add withdrawal functionality at a later date
- The Coinbase API provides a playground environment with a faucet to help test out wallet functionality
- The ETH and other assets obtained in this environment hold **no real-world monetary value** and are intended for testing purposes only
- Only Ethereum (ETH) is supported for transactions. Future updates will include a gasless option to minimize transaction costs and support for stablecoins to provide a more predictable payment option.
- Encryption for user data has not been implemented yet but is planned for a future update to ensure privacy and security

## License
This project is licensed under the [MIT License](LICENSE).

## Contact
Vivian Davila - [viviananddav@gmail.com](mailto:youremail@example.com)
Project Link: [GitHub Repository](https://github.com/viviancreates/tanda)
