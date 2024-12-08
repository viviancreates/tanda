# Tanda

## Description
The Tanda App is a Ruby application that allows users to set saving goals and track them with friends and family.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

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

## License
Distributed under the MIT License. See `LICENSE` for more information.

## Contact
Vivian Davila - [viviananddav@gmail.com](mailto:youremail@example.com)
Project Link: [https://github.com/yourusername/yourproject](https://github.com/yourusername/yourproject)
