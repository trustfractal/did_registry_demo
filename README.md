# DID Registry demo

A guide on how to interact with Fractal's [DID Registry](https://github.com/trustfractal/web3-identity#option-2-did-registry-lookup).

## ⚠️ Work in Progress ⚠️

We're still building this guide. If you need help today, get in touch through <sales@fractal.id>.

## Overview

In order to get our hands dirty with some mock data, we will:

- Deploy a mock version of Fractal's [DID Registry](https://github.com/trustfractal/web3-identity/blob/main/FractalRegistry.sol)
- Understand how Fractal operates this contract
- Create voting contract, and require its vote function to only be called once per person
- Create a mintable ERC20 token, and require its mint function to be called by KYC-approved addresses

## Setup and deploy

This guide includes step-by-step demonstration sections. We encourage you to have a first shallow read, without going into the demonstration, in order to familiarize yourself with the concepts. After that, go through the demonstractions, in order to get hands-on experience and build a strong intuition.

For these demonstrations, we'll be using Remix IDE, which includes an in-browser Ethereum implementation, so we don't spend real money or have to chase down testnet faucets. However, don't worry, real-word operation is effectively identical, everything you'll see here can also be done with [Hardhat](https://hardhat.org/) or any other EVM toolchain you prefer.

<details>
  <summary>👁 Step-by-step demonstration</summary>

Let's get started! First off, let's start by deploying and

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

When a user submits their documents and our identity specialist verify their identity, if they've associated an EVM address with their account, our servers call `addUserAddress` with the user's address and a personal unique id.

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
      Normally, when Fractal's server call this method, this value is a personal unique identifier.
  - Click "transact"
  </details>

Fractal's servers also make a few `addUserToList` calls with the relevant lists. There are three categories of lists:

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

We've now successfully emulated Fractal's operation of the contract, and we can now see how we'd interact with it to check a user's status.

</details>

### Consulting state

With this data on the contract, we're now able to preform two operations: check if an address belongs to a unique user, and check which lists the users belongs to.

### User uniqueness

By calling `getFractalId` with an address, you get back the user's personal unique identifier within Fractal's system. If two addresses return the same identifier, you can be sure they belong to the same person. Conversely, if two addresses return different identifiers, you can be sure they belong to different people.

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

This is us getting back the same identifier we've inputed before in this guide.

</details>

An example use case is having a voting contract where you require the voter to be in Fractal's DID registry and for a person to only be able to cast one vote.

Here's a stripped down version of what that could look like:

```solidity
    function vote(uint8 option) external {
        bytes32 fractalId = FractalRegistry(OXADDRESS).getFractalId(msg.sender);

        require(!has_voted[fractalId], "Same person can't vote twice.");
        has_voted[fractalId] = true;

        votes[option] += 1;
    }
```

<details>
  <summary>👁 Step-by-step demonstration</summary>

</details>

### User has passed KYC

isUserInList

### On user change or document expiration

removeUserAddress
removeUserFromList

## On-chain usage example

## Javascript usage example
