# DID Registry demo

A guide on how to interact with Fractal's [DID Registry](https://www.notion.so/fractal/Fractal-Product-Overview-2c63841aebaf4000b96f1c44c1680ad1#44aec71477e347bbbba4a4bd7d3169a3).

See something wrong? Open up a pull request!

See something that's confusing or just not immediately obvious? Open up an issue!

## ⚠️ Work in Progress ⚠️

We're still building this guide. If you need help today, get in touch through <engineering@fractal.id>.

## Overview

To get our hands dirty with some mock data, we will go through:

- Deploy our own copy of Fractal's [DID Registry](https://github.com/trustfractal/web3-identity/blob/main/FractalRegistry.sol)
- Operation of the contract
- Usage examples
  - One person, one vote
  - Require KYC approval for buying tokens

## Deploy our own copy of Fractal's DID Registry

For these demonstrations, we'll deploy our own copy of Fractal's DID Registry. We'll be using [Remix IDE](https://remix.ethereum.org/), which includes an in-browser Ethereum implementation. This way we don't spend real money or have to chase down testnet faucets. Don't worry, real-world operation is effectively identical, everything you'll see here can also be done with [Hardhat](https://hardhat.org/) or any other EVM toolchain you prefer.

<details>
  <summary>👁 Step-by-step demonstration</summary>

In order to make this guide accessible to non-blockchain developers, we've included step-by-step screenshots. If you're a blockchain developer and you're familiar with Remix IDE, feel free to skip these.

Let's get started! First off, let's start by deploying our own copy of a FractalRegistry.

- Go to [Remix IDE](https://remix.ethereum.org/) and clone this git repo as a workspace.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - On your browser, go to `https://remix.ethereum.org/`. Accept or decline their analytics collection.

    <img src="media/01-01.png" />

  - Click through the welcome wizard.

    <img src="media/01-02.png" />

  - The Remix IDE should now be ready to be used. You should look like this:

    <img src="media/01-03.png" />

  - Click on "Clone Git Repository"

    <img src="media/01-04.png" />

  - Input `https://github.com/trustfractal/did_registry_demo` and click "Ok"

    <img src="media/01-05.png" />

  - Remix will take a few seconds to do the clone. After it's done, you should see new files on the left bar:

    <img src="media/01-06.png" />

  </details>

- Compile and deploy the `contracts/1_FractalRegistry.sol` contract. Use your own address as the `root` constructor argument.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - On the file browser on the left, click "contracts", and then "1_FractalRegistry.sol".

    <img src="media/01-07.png" />

  - With that file open, click on the "Solidity compiler" tab

    <img src="media/01-08.png" />

  - Click on the "Compile 01_FractalRegistry.sol" button

    <img src="media/01-09.png" />

  - Everything should go well, and you should see a green checkmark on the tab

    <img src="media/01-10.png" />

  - Next, click on the "Deploy & run transactions" tab

    <img src="media/01-11.png" />

  - We're now going to deploy the contract we've just compiled. In order to do that, this specific contract needs to know who will be able to change its state. That's going to be the account we're currently using. Click on the "Copy account to clipboard" button.

    <img src="media/01-13.png" />

  - Paste it on the box to the right of the "Deploy" button, and press that button.

    <img src="media/01-14.png" />

  - The contract is now deployed. You should be able to see three consequences:

    1. You should see a success message on the console on the bottom.
    2. Your account's balance went down a little bit. This is because it was spent as gas as part of the deployment.
    3. You should now have a contract entry on the bottom left.

      <img src="media/01-15.png" />

  We now have a working FractalRegistry deployment to play around with! 🎉

  </details>

</details>

## Operation of the contract

So, what does Fractal do with the contract? And, more importantly, what can we do with it?

### On user KYC approval

When a user submits their documents and our identity specialist verify their identity, our servers call `addUserAddress` with two arguments:

- the user's EVM address
- a personally unique identifier, called `fractalId`

In order to be sure we're not duplicating users and we know their wallet address, a user needs to be onboarded with one of the following level combinations, with optionally more add-ons:

- `uniqueness+wallet`
- `basic+uniq+wallet`
- `plus+uniq+wallet`

<details>
  <summary>👁 Step-by-step demonstration</summary>

Let's use ourselves as an example. Let's pretend Fractal assigned us the `fractalId` of `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF`.

- Make a `addUserAddress` call with:

  - `addr`: our own address
  - `fractalId`: `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF`

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Click on the arrow to the left of the deployed contract. This will reveal the contract's functions.

      <img src="media/02-01.png" />

  - Scroll down and click on the arrow to the right of "addUserAddre...". This will show the input boxes to put in arguments to make a call to `addUserAddress`.

      <img src="media/02-02.png" />

  - Scroll all the way up, and copy your own address.

      <img src="media/02-03.png" />

  - Scroll back down to the `addUserAddress` input boxes, and paste your own address in the `addr` box.

      <img src="media/02-04.png" />

  - Paste `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF` on the `fractalId` box.

      <img src="media/02-05.png" />

  - Click "transact".

      <img src="media/02-06.png" />

  - The transaction should go through successfully. You should see a new green checkmark appear in the console informing us that the call to `FractalRegistry.addUserAddress` has been successful.

      <img src="media/02-07.png" />

  </details>

</details>

Fractal's servers also make a few `addUserToList` calls with the relevant lists. There are three categories of lists:

- KYC level

  There are two lists -- `basic` and `plus` -- which correspond to the [KYC levels](https://docs.developer.fractal.id/kyc-levels). If a user is in one of these two lists, they have passed the KYC checks for that level.

- Residency

  There's a list per country, with the format `residency_XX`, where `XX` is the [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code. For example, Spain has the code `es`, and there's a corresponding `residency_es` list. If a user is in one of these lists, Fractal has verified they reside in the respective country.

- Citizenship

  There's a list per country, with the format `citizenship_XX`, where `XX` is the [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code. For example, Italy has the code `it`, and there's a corresponding `citizenship_it` list. If a user is in one of these lists, Fractal has verified they are a citizen of the respective country.

<details>
  <summary>👁 Step-by-step demonstration</summary>

Let's pretend we're a Swedish citizen (`se`) living in the Åland Islands (`ax`) that has passed the Plus KYC level (`plus`).

- Make a `addUserToList` call with:

  - `userId`: `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF`
  - `listId`: `citizenship_se`

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Look for, and click on the arrow to the right of `addUserToList`.

      <img src="media/02-08.png" />

  - Paste `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF` on the `userId` box.

      <img src="media/02-09.png" />

  - Paste `citizenship_se` on the `listId` box.

      <img src="media/02-10.png" />

  - Click "transact".

      <img src="media/02-11.png" />

  - The transaction should go through successfully. You should see a new green checkmark appear in the console informing us that the call to `FractalRegistry.addUserToList` has been successful.

      <img src="media/02-12.png" />

  </details>

- Make a `addUserToList` call with:

  - `userId`: `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF`
  - `listId`: `residency_ax`

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Paste `residency_ax` on the `listId` box.

      <img src="media/02-13.png" />

  - Click "transact".

      <img src="media/02-14.png" />

  - The transaction should go through successfully. You should see a new green checkmark appear in the console informing us that the call to `FractalRegistry.addUserToList` has been successful.

      <img src="media/02-15.png" />

  </details>

- Make a `addUserToList` call with:

  - `userId`: `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF`
  - `listId`: `plus`

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Paste `plus` on the `listId` box.

      <img src="media/02-16.png" />

  - Click "transact".

      <img src="media/02-17.png" />

  - The transaction should go through successfully. You should see a new green checkmark appear in the console informing us that the call to `FractalRegistry.addUserToList` has been successful.

      <img src="media/02-18.png" />

  </details>

</details>

### Consulting state

With this data on the contract, we're now able to preform two operations: check if an address belongs to a unique user, and check which lists the users belongs to.

### User uniqueness

By calling `getFractalId` with an address, you get back its controlling user's `fractalId`. If two addresses return the same identifier, you can be sure they belong to the same person. Conversely, if two addresses return different identifiers, you can be sure they belong to different people.

If `getFractalId` returns `0`, that means the address isn't associated with any user known to Fractal. Be sure to check its return value!

<details>
  <summary>👁 Step-by-step demonstration</summary>

Let's see how to contract responds to querying for own address, and an arbitrary address that's not in the contract.

- Make a `getFractalId` call with:
  - `addr`: your own address
- Verify that you get our `fractalId` back.

  `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF`

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Look for, and click on the arrow to the right of `getFractalId`.

      <img src="media/03-01.png" />

  - Scroll all the way up, and copy your own address.

      <img src="media/03-02.png" />

  - Paste your own address on the `addr` box.

      <img src="media/03-03.png" />

  - Click "call".

      <img src="media/03-04.png" />

  - The call should be successful. Remix does output some details to the console but, more importantly, the result of the call is displayed just below it. We can see that our call returned `0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef`, which is the `fractalId` we assigned to our address previously in this guide.

      <img src="media/03-05.png" />

  </details>

- Make a `getFractalId` call with:
  - `addr`: some arbitrary valid address. Here's an example: `0x05a56E2D52c817161883f50c441c3228CFe54d9f`
- Verify that you get back zero:

  `0x0000000000000000000000000000000000000000000000000000000000000000`

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Paste `0x05a56E2D52c817161883f50c441c3228CFe54d9f` on the `addr` box.

      <img src="media/03-06.png" />

  - Click "call".

      <img src="media/03-07.png" />

  - The call should be successful and have returned `0x0000000000000000000000000000000000000000000000000000000000000000`.

      <img src="media/03-08.png" />

  </details>

</details>

### KYC levels, residency, and citizenship

After you get the user's `fractalId`, you can then check their presence on the Registry's lists with `isUserInList`, which enables you to effectively check their KYC status, residency, and citizenship.

Here are a few examples:

```solidity
// Plus KYC level, and not resident in Fiji, and not a Iceland citizen.
registry.isUserInList(fractalId, "plus") &&
    !registry.isUserInList(fractalId, "residency_fj") &&
    !registry.isUserInList(fractalId, "citizenship_is")

// Basic KYC level, and resides in Portugal or Spain.
registry.isUserInList(fractalId, "basic") &&
    (
      registry.isUserInList(fractalId, "residency_pt") ||
      registry.isUserInList(fractalId, "residency_es")
    )

// Basic or Plus KYC level, no residency or citizenship requirements.
registry.isUserInList(fractalId, "basic") ||
    registry.isUserInList(fractalId, "plus")
```

<details>
  <summary>👁 Step-by-step demonstration</summary>

Let's see how to contract responds to querying for own lists, and an some other arbitrary ones.

- Make a `isUserInList` call with:
  - `userId`: `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF`
  - `listId`: `citizenship_se`
- Verify that you get back `true`.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Look for, and click on the arrow to the right of `isUserInList`.

      <img src="media/03-09.png" />

  - Paste `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF` on the `userId` box.

      <img src="media/03-10.png" />

  - Paste `citizenship_se` on the `listId` box.

      <img src="media/03-11.png" />

  - Click "call".

      <img src="media/03-12.png" />

  - The call should be successful and have returned `true`.

      <img src="media/03-13.png" />

  </details>

- Make a `isUserInList` call with:
  - `userId`: `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF`
  - `listId`: `residency_ax`
- Verify that you get back `true`.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Paste `residency_ax` on the `listId` box.

      <img src="media/03-14.png" />

  - Click "call".

      <img src="media/03-15.png" />

  - The call should be successful and have returned `true`.

      <img src="media/03-16.png" />

  </details>

- Make a `isUserInList` call with:
  - `userId`: `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF`
  - `listId`: `citizenship_dk`
- Verify that you get back `false`.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Paste `citizenship_dk` on the `listId` box.

      <img src="media/03-17.png" />

  - Click "call".

      <img src="media/03-18.png" />

  - The call should be successful and have returned `false`.

      <img src="media/03-19.png" />

  </details>

- Make a `isUserInList` call with:
  - `userId`: `0x0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF`
  - `listId`: `residency_fi`
- Verify that you get back `false`.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Paste `residency_fi` on the `listId` box.

      <img src="media/03-20.png" />

  - Click "call".

      <img src="media/03-21.png" />

  - The call should be successful and have returned `false`.

      <img src="media/03-22.png" />

  </details>

</details>

### On user change or document expiration

There's two other relevant public functions on the contract. Going over them briefly:

- When a user removes (or changes) their associated EVM address, Fractal's servers call `removeUserAddress` appropriately (and, on change, also call `addUserAddress`).
- When a user submits new information that changes their KYC, residency, or citizenship status, Fractal's servers will make the appropriate `removeUserFromList` (and possibly `addUserToList`) calls to keep the user's on-chain information up-to-date.

## Usage examples

### One person, one vote

An example use case of `fractalId`'s pre-person uniqueness is having a voting contract where you require the voter to be in the Registry and for a person to only be able to cast one vote, effectively requiring unique personhood and achieving Sybil-resistance.

Here's a simplified example:

```solidity
function vote(uint8 option) external {
    bytes32 fractalId = FractalRegistry(OXADDRESS).getFractalId(msg.sender);
    require(fractalId != 0, "User must be present in FractalRegistry.");
    require(!hasVoted[fractalId], "Same person can't vote twice.");

    hasVoted[fractalId] = true;
    votes[option] += 1;
}
```

<details>
  <summary>👁 Step-by-step demonstration</summary>

The Voting contract, which can be found at `contracts/2_Voting.sol`, only has 3 relevant operations:

- Being deployed. Its constructor requires two arguments: the number of options we're voting for (i.e., how different choices are in our ballot) and the address for the FractalRegistry contract.
- Vote. It takes a single argument, the option you're voting for.
- Tallying the results. This returns the current vote count for each option.

Let's try it out and see how it behaves!

- Compile and deploy the `contracts/2_Voting.sol` contract. For constructor arguments, use:

  - `options`: `4`. Nothing special about this choice.
  - `registryAddress`: the address of the FractalRegistry we've been using.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - On the file browser on the left, click "contracts", and then "contracts/2_Voting.sol".

    <img src="media/04-01.png" />

  - With that file open, click on the "Solidity compiler" tab.

    <img src="media/04-02.png" />

  - Click on the "Compile 2_Voting.sol" button.

    <img src="media/04-03.png" />

  - Everything should go well, and you should see a green checkmark on the tab.

    <img src="media/04-04.png" />

  - Next, click on the "Deploy & run transactions" tab.

    <img src="media/04-05.png" />

  - Make sure the Voting contract is selected.

    <img src="media/04-06.png" />

  - Click on the arrow to the right of the Deploy button. This should show the argument input boxes.

    <img src="media/04-07.png" />

  - Copy your FractalRegistry address.

    <img src="media/04-08.png" />

  - Input `4` in the `options` box.

    <img src="media/04-09.png" />

  - Paste it in the `registryAddress` box.

    <img src="media/04-10.png" />

  - Click "transact".

    <img src="media/04-11.png" />

  - The contract is now deployed. You should see a success message on the console on the bottom.

    <img src="media/04-12.png" />

  - If you scroll all the way to the bottom, you should now have a Voting contract entry.

    <img src="media/04-13.png" />

  </details>

- Let's call `currentTally`. It should show that all four options have zero votes.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Click on the arrow to the left of the deployed contract. This will reveal the contract's functions.

      <img src="media/04-14.png" />

  - Click on "currentTally".

      <img src="media/04-15.png" />

  - You should see 4 zeros: `[0, 0, 0, 0]`.

      <img src="media/04-16.png" />

  </details>

- Let's call `vote` with option `1`. It should succeed.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Click on the arrow to the right of "vote".

      <img src="media/04-17.png" />

  - Input `1` on the `option` box.

      <img src="media/04-18.png" />

  - Click "transact".

      <img src="media/04-19.png" />

  - The transaction should succeed, and you should see a new green checkmark appear in the console.

      <img src="media/04-20.png" />

  </details>

- Let's call `currentTally` again. It should show that option `1` has one vote, and that options `0`, `2`, and `3` have all zero votes.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Click on "currentTally" again.

      <img src="media/04-21.png" />

  - It should now return `[0, 1, 0, 0]`.

      <img src="media/04-22.png" />

  </details>

- Let's try calling `vote` again. This time, it should fail, with the reason "Already voted: the same person can't vote twice."

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Click on "vote" again.

      <img src="media/04-23.png" />

  - You should see a red cross on the console, meaning the transaction failed. It should also read the reason: "Already voted: the same person can't vote twice."

      <img src="media/04-24.png" />

  </details>

- Let's try calling `vote` with a different address, one that's not registered in our FractalRegistry contract. It should fail, with the reason "Unregistered user: user must be present in FractalRegistry."

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Scroll all the way up, and select the second account. This now becomes our address.

      <img src="media/04-25.png" />

  - Scroll all the way back down to "vote" and click it again.

      <img src="media/04-26.png" />

  - You should see a red cross on the console, meaning the transaction failed. It should also read the reason: "Unregistered user: user must be present in FractalRegistry."

      <img src="media/04-27.png" />

  - In order to not confuse ourselves in later steps, let's select the first account again.

      <img src="media/04-28.png" />

  </details>

- Let's call `currentTally` again. Even though we tried to execute a bunch of invalid votes, it should return the same results as before.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Click on "currentTally" again.

      <img src="media/04-29.png" />

  - It should still return `[0, 1, 0, 0]`.

      <img src="media/04-30.png" />

  </details>

</details>

### Require KYC approval for buying tokens

An example use case of `fractalId` presence in specific lists is, in order to buy some ERC20 token, check that a user has passed KYC and that they're of a particular residency or citizenship.

Here's a simplified example:

```solidity
function buy() external payable {
  FractalRegistry registry = FractalRegistry(OXADDRESS);
  bytes32 fractalId = registry.getFractalId(msg.sender);
  require(
      fractalId != 0 &&
          registry.isUserInList(fractalId, "plus") &&
          !registry.isUserInList(fractalId, "residency_fj") &&
          !registry.isUserInList(fractalId, "citizenship_is"),
      "Non KYC-compliant sender. "
        "Must have cleared `plus` level, "
        "not reside in Fiji, and "
        "not be a Iceland citizen"
  );

  _mint(msg.sender, msg.value);
}
```

<details>
  <summary>👁 Step-by-step demonstration</summary>

The DemoToken contract, which can be found at `contracts/3_DemoToken.sol`, is a toy ERC20 token with a `buy` function that, when it receives funds from a KYC-approved account with the `plus` level, mints (i.e. creates) new tokens. In order to portray the common requirement of disallowing certain countries, the contract rejects Fiji (`fj`) residents and Iceland (`is`) citizens.

In order to make things simpler, we're going to be reusing the [OpenZeppelin's ERC20 implementation](https://docs.openzeppelin.com/contracts/4.x/erc20). It brings along a lot of standard ERC20 functions but, for this demo, we only care about `balance`, which will let us check our balance.

Let's try it out and see it working!

- Compile and deploy the `contracts/3_DemoToken.sol` contract. For constructor arguments, use:

  - `registryAddress`: the address of the FractalRegistry we've been using.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - On the file browser on the left, click "contracts", and then "contracts/3_DemoToken.sol".

    <img src="media/05-01.png" />

  - With that file open, click on the "Solidity compiler" tab.

    <img src="media/05-02.png" />

  - Click on the "Compile 3_DemoToken.sol" button.

    <img src="media/05-03.png" />

  - Everything should go well, and you should see a green checkmark on the tab.

    <img src="media/05-04.png" />

  - Next, click on the "Deploy & run transactions" tab.

    <img src="media/05-05.png" />

  - Make sure the DemoToken contract is selected.

    <img src="media/05-06.png" />

  - Click on the arrow to the right of the Deploy button. This should show the argument input box.

    <img src="media/05-07.png" />

  - Copy your FractalRegistry address.

    <img src="media/05-08.png" />

  - Paste it in the `registryAddress` box.

    <img src="media/05-09.png" />

  - Click "transact".

    <img src="media/05-10.png" />

  - The contract is now deployed. You should see a success message on the console on the bottom. If you scroll all the way to the bottom on the left, you should now have a DemoToken contract entry.

    <img src="media/05-11.png" />

  </details>

- Let's call `balance` for our own address. Since we didn't buy any tokens yet, it should be zero.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Scroll all the way up, and copy your own address.

    <img src="media/05-12.png" />

  - Scroll back down, and paste it on the box to the right of "balanceOf" button. Press it to make the call.

    <img src="media/05-13.png" />

  - It should return `0`.

    <img src="media/05-14.png" />

  </details>

- Let's call `buy` with 42 Wei. Since we're in the `plus` list, we're not in the `residency_fj` list, and we're also not in the `citizenship_is` list, we should be successful!

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Scroll all the way up, until you see the "Value" input box, and put `42` in it.

    <img src="media/05-15.png" />

  - Scroll back down, and click the "buy" button.

    <img src="media/05-16.png" />

  - The transaction should succeed, and you should see a new green checkmark appear in the console.

      <img src="media/05-17.png" />

  </details>

- Let's call `balance` again. It should now return 42.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Click "balanceOf" again. It should now return `42`.

    <img src="media/05-18.png" />

  </details>

- In order to see an example of a non-compliant person trying to buy tokens, let's pretend we moved from the Åland Islands (`ax`) to Fiji (`fj`). Let's remove our `fractalId` from the list `residency_ax` add it to `residency_fj`.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - If necessary, click on the arrow to the left of the FractalRegistry contract. This will reveal the contract's functions.

    <img src="media/05-19.png" />

  - If necessary, click on the arrow to the right of "removeUserFr...". This will reveal the function's argument input boxes.

    <img src="media/05-20.png" />

  - In the "userId" box, input `0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef`.

    <img src="media/05-21.png" />

  - In the "listId" box, input `residency_ax`.

    <img src="media/05-22.png" />

  - Click "transact".

    <img src="media/05-23.png" />

  - The transaction should succeed, and you should see a new green checkmark appear in the console.

      <img src="media/05-24.png" />

  - If necessary, click on the arrow to the right of "addUserToList". This will reveal the function's argument input boxes.

    <img src="media/05-25.png" />

  - In the "userId" box, input `0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef`.

    <img src="media/05-26.png" />

  - In the "listId" box, input `residency_fj`.

    <img src="media/05-27.png" />

  - Click "transact".

    <img src="media/05-28.png" />

  - The transaction should succeed, and you should see a new green checkmark appear in the console.

      <img src="media/05-29.png" />

  </details>

- Let's try calling `buy` again. Since our residency is now on Fiji (`fj`), which is marked as disallowed, the contract now refuses the transaction.

  <details>
    <summary>📸 Step-by-step screenshots</summary>

  - Click on "buy" again.

      <img src="media/05-30.png" />

  - You should see a red cross on the console, meaning the transaction failed. It should also read the reason: "Non KYC-compliant sender."

      <img src="media/05-31.png" />

  </details>

</details>

## Using client-side JavaScript

Since the main goal of the DID Registry is to be a readable resource, you can also use it off chain directly from your dApp's code!

> ⚠️ TODO Add a brief web3.js example.

> ⚠️ TODO Add contract addresses (for the various networks) and ABI. They're now at <https://github.com/trustfractal/registry-deployer/tree/master/deployments>

> ⚠️ TODO Point people at <https://github.com/trustfractal/did-registry-demo-dapp>
