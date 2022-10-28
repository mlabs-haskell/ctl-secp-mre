module Main (main) where

import Contract.Prelude

import Contract.Config
  ( PrivatePaymentKeySource(..)
  , WalletSpec(..)
  , testnetConfig
  )
import Contract.Monad (Contract, launchAff_, runContract)
import Contract.Transaction (awaitTxConfirmed)
import Control.Monad.Error.Class (try)
import Control.Monad.Except (throwError)
import Effect.Exception (error)
import Effect.Exception as Exception
import Node.Process (lookupEnv)
import PoCECDSA (prepTest, testSecpV1, testSecpV4)

-- | Main entrypoint for the CTL CLI
main ∷ Effect Unit
main = do
  maybeSkey ← lookupEnv "SIGNING_KEY_FILE"

  case maybeSkey of

    Nothing → throwError
      (error "Environment variable SIGNING_KEY_FILE is missing.")
    Just skey →
      do
        let
          config = testnetConfig
            { walletSpec = Just $ UseKeys (PrivatePaymentKeyFile skey) Nothing
            , logLevel = Info
            }
        launchAff_ do
          runContract config do
            (prepTest >>= traverse_ awaitTxConfirmed)
            test "Test case 1 (v1.35.1 compatible)"
              (testSecpV1 >>= awaitTxConfirmed)

          runContract config do
            (prepTest >>= traverse_ awaitTxConfirmed)
            test "Test case 2 (v1.35.4 compatible)"
              (testSecpV4 >>= awaitTxConfirmed)

test ∷ String → Contract () Unit → Contract () Unit
test testName contract = do
  result ← try contract
  case result of
    Right _ → pure unit
    Left e → do
      log (testName <> " failed:")
      log (Exception.message e)
