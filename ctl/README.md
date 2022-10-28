# Testing SECP primitives using CTL

To run this test scenario:

1. Set the path of your payment signing key as an environment variable: `export export SIGNING_KEY_FILE=/path/to/skey`
2. Set up a local instance of ogmios, ogmios-datum-cache and ctl-server (see the documentation [here](https://github.com/Plutonomicon/cardano-transaction-lib/blob/6828a0c5d0bb94fac389f0775693d1d11bcc38af/doc/runtime.md#manually-starting-the-runtime-components))
3. Run `nix run .#ctl-main`

## Test results

### Test case 1

Using the 1.35.1 version of secp (incorrect representation)

msg: `16e0bf1f85594a11e75030981c0b670370b3ad83a43f49ae58a2fd6f6513cde9`

sig (internal representation): `6fbc0da8a7db783c2e8adb2262339a0cd1ca584307821c65a918b329de6ee131852b89eac6984065f59051aa05ba38a0733b93c0ea9163abb059bd5fd0b66475`

pk (internal representation): `048379352db5140c4a39137dd08c69193af732a7ceee3e6ff8cb07e37ce82e035579551734d7d9e4b6853d45c4a7846d5ef570e56f0353f83dad3b478a5f6699`

```
[DEBUG] 2022-10-28T15:19:55.140Z message: {"type":"jsonwsp/response","version":"1.0","servicename":"ogmios","methodname":"SubmitTx","result":{"SubmitF0},"maxExeail":[{"validationTagMismatch":null}]},"reflection":"SubmitTx-hlil91il9sn4su4"}
/Users/gergo/Dev/mlabs/ctl-secp-mre/ctl/output/Effect.Aff/foreign.js:532
                throw util.fromLeft(step);
                ^

Error: `submit` call failed. Error from Ogmios: [{"validationTagMismatch":null}]
    at Object.exports.error (/Users/gergo/Dev/mlabs/ctl-secp-mre/ctl/output/Effect.Exception/foreign.js:8:10)
```

### Test case 2

Using the 1.35.4 version of secp (correct representation)

msg: `16e0bf1f85594a11e75030981c0b670370b3ad83a43f49ae58a2fd6f6513cde9`

sig (DER): `304402205fb12954b28be6456feb080cfb8467b6f5677f62eb9ad231de7a575f4b68575102202754fb5ef7e0e60e270832e7bb0e2f0dc271012fa9c46c02504aa0e798be6295`

pk (DER): `0392d7b94bc6a11c335a043ee1ff326b6eacee6230d3685861cd62bce350a172e0`

```
[DEBUG] 2022-10-28T15:23:30.425Z message: {"type":"jsonwsp/response","version":"1.0","servicename":"ogmios","methodname":"EvaluateTx","result":{"EvaluationFailure":{"ScriptFailures":{"spend:0":[{"validatorFailed":{"error":"An error has occurred:  User error:\nThe machine terminated because of an error, either from a built-in function or from an explicit use of 'error'.\nCaused by: [\n  [\n    [\n      (builtin verifyEcdsaSecp256k1Signature)\n      (con\n        bytestring\n        #0392d7b94bc6a11c335a043ee1ff326b6eacee6230d3685861cd62bce350a172e0\n      )\n    ]\n    (con\n      bytestring\n      #16e0bf1f85594a11e75030981c0b670370b3ad83a43f49ae58a2fd6f6513cde9\n    )\n  ]\n  (con\n    bytestring\n    #304402205fb12954b28be6456feb080cfb8467b6f5677f62eb9ad231de7a575f4b68575102202754fb5ef7e0e60e270832e7bb0e2f0dc271012fa9c46c02504aa0e798be6295\n  )\n]","traces":["ECDSA SECP256k1 signature verification: Invalid verification key."]}}]}}},"reflection":"EvaluateTx-hlil9hbl9sn9exp"}
/Users/gergo/Dev/mlabs/ctl-secp-mre/ctl/output/Effect.Aff/foreign.js:532
                throw util.fromLeft(step);
                ^

Error: Error: ExUnitsEvaluationFailed: Script failures:
- Spend:0
  - Redeemer: (Constr fromString "0" [(Bytes (hexToByteArrayUnsafe "16e0bf1f85594a11e75030981c0b670370b3ad83a43f49ae58a2fd6f6513cde9")),(Bytes (hexToByteArrayUnsafe "304402205fb12954b28be6456feb080cfb8467b6f5677f62eb9ad231de7a575f4b68575102202754fb5ef7e0e60e270832e7bb0e2f0dc271012fa9c46c02504aa0e798be6295")),(Bytes (hexToByteArrayUnsafe "0392d7b94bc6a11c335a043ee1ff326b6eacee6230d3685861cd62bce350a172e0"))])
  - Input: (TransactionInput { index: 1u, transactionId: (TransactionHash (hexToByteArrayUnsafe "af6205477838ed3fd95c4a946c2cad17dc3e0dc3787cea452e9731a87fbfc8ad")) })
  - An error has occurred:  User error:
    The machine terminated because of an error, either from a built-in function or from an explicit use of 'error'.
    Caused by: [
      [
        [
          (builtin verifyEcdsaSecp256k1Signature)
          (con
            bytestring
            #0392d7b94bc6a11c335a043ee1ff326b6eacee6230d3685861cd62bce350a172e0
          )
        ]
        (con
          bytestring
          #16e0bf1f85594a11e75030981c0b670370b3ad83a43f49ae58a2fd6f6513cde9
        )
      ]
      (con
        bytestring
        #304402205fb12954b28be6456feb080cfb8467b6f5677f62eb9ad231de7a575f4b68575102202754fb5ef7e0e60e270832e7bb0e2f0dc271012fa9c46c02504aa0e798be6295
      )
    ]
  - Trace:
    1.  ECDSA SECP256k1 signature verification: Invalid verification key.
```
