# DID Registry demo

A guide on how to interact with Fractla's [DID Registry](https://github.com/trustfractal/web3-identity#option-2-did-registry-lookup).

## ⚠️ Work in Progress ⚠️

We're still building this guide. If you need help today, get in touch through <sales@fractal.id>.

## Overview

In order to get our hands dirty with some mock data, we will:

- Deploy a mock version of Fractal's [DID Registry](https://github.com/trustfractal/web3-identity/blob/main/FractalRegistry.sol) using [Remix IDE](https://remix.ethereum.org/)
- Understand how Fractal operates this contract
- Create a mintable ERC20 token, and require its mint function to be called by KYC-approved addresses

## Setup and deploy

Remix IDE includes an in-browser Ethereum implementation, which we'll be using in this guide (so we don't spend money not have to chase down testnet faucets). Don't worry, real-word operation is effectively identical, everything you'll see here can also be done with [Hardhat](https://hardhat.org/) or any other EVM toolchains you prefer.

So, let's get started!

<details>
  <summary>👁 Step-by-step demonstration</summary>

- Go to [Remix IDE](https://remix.ethereum.org/)
- Clone this git repo as a workspace
- Compile and deploy the contract
  - On the file explorer on the left
    - Click "contracts"
    - Click "1_FractalRegistry.sol"
  - Go to the "Solidity compiler" tab
    - Click "Compile 1_FractalRegistry.sol".
  - Go to the "Deploy & run transactions"
    - Copy your address
    - Paste it on the box to the right of the Deploy button
    - Click Deploy

That's it! 🎉 We now have a working FractalRegistry deployment to play around with!

</details>

## Operation of the contract

So, what does Fractal do with it? And, more importantly, what can we do with it?

### On user KYC approval

When a user submits their documents and our identity specialist verify their identity, if they've associated an EVM address with their account, our servers call `addUserAddress` with the user's address and personally unique id.

<details>
  <summary>👁 Step-by-step demonstration</summary>

Let's use ourselves as an example.

- Go to the "Deploy & run transactions"
  - Click the arrow on the left of "FRACTALREGISTRY", below "Deployed Contracts"
  - Click the arrow on the right of "addUserAddre..."
    - On the `addr` field, paste your own address
    - On the `fractalId` field, let's paste:
      ```
      0x0000000000000000000000000000000000000000000000000000000000000001
      ```
      Normally, when Fractal's server call this method, this value is a personally unique identifier.
  - Click "transact"
  </details>

Furthermore, Fractal's servers also make a few `addUserToList` calls with the relevant lists. There's three categories of lists:

- KYC level

  There's two lists -- `basic` and `plus` -- corresponding to the [KYC levels](https://docs.developer.fractal.id/kyc-levels). If a user is in the list, they have passed the KYC checks for that level.

- Residency

  There's is a list per country, with the format `residency_XX`, where `XX` is the [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code. For example, Spain has the code `es`, and there's a corresponding `residency_es` list. If a user is in one of these lists, Fractal has verified they reside in the respective country.

- Citizenship

  There's is a list per country, with the format `citizenship_XX`, where `XX` is the [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code. For example, Italy has the code `it`, and there's a corresponding `citizenship_it` list. If a user is in one of these lists, Fractal has verified they are a citizen of the respective country.

<details>
  <summary>👁 Step-by-step demonstration</summary>

Let's use ourselves as an example. Let's pretend we're a Portuguese citizen (`pt`) that lives in Finland (`fi`) that has passed KYC level `plus`.

- Go to the "Deploy & run transactions"

  - Click the arrow on the left of "FRACTALREGISTRY", below "Deployed Contracts"
  - Click the arrow on the right of "addUserToList"
    - On the `userId` field, paste the fractalId we've used before:
      ```
      0x0000000000000000000000000000000000000000000000000000000000000001
      ```
    - On the `listId` field, put in `plus`
  - Click "transact"

    You should see an entry on the console (bottom portion of the window) with a big green checkmark. This indicates success! 🎉

  - Let's do another "addUserToList" call for our citizenship
    - On the `listId` field, put in `citizenship_pt`
  - Let's do another "addUserToList" call for our residency
    - On the `listId` field, put in `residency_fi`
  - Click "transact"

        You should see another success checkmark on the console

    </details>

We've now successfully emulated Fractal's operation of the contract, and we can now see how we'd interacti with it to check a user's status.

### Consulting state

With this data on the contract, we're now enabled to preform two operations: check if an address belongs to a unique user, and check which lists the users belongs to.

### User uniqueness

By calling `getFractalId` with an address, you get back the user's personally unique identifier within Fractal's system. If two addresses return the same identifier, you can be sure they belong to the same person. Conversely, if two addresses return different identifiers, you can be sure they belong to different people.

<details>
  <summary>👁 Step-by-step demonstration</summary>

Let's use ourselves as an example.

- Go to the "Deploy & run transactions"
  - Click the arrow on the left of "FRACTALREGISTRY", below "Deployed Contracts"
  - Click the arrow on the right of "getFractalId"
    - On the `addr` field, paste your own address
  - Click "call"
  - Below the "call" button, you should now see:
    ```
    0: bytes32: 0x0000000000000000000000000000000000000000000000000000000000000001
    ```

This is us getting beck the same identified we're inputed before in this guide.

</details>

An example use case is having

### User has passed KYC

isUserInList

### On user change or document expiration

removeUserAddress
removeUserFromList

## On-chain usage example

## Javascript usage example
