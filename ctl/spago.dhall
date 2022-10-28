{ name = "ctl-test"
, dependencies =
  [ "bigints"
  , "cardano-transaction-lib"
  , "exceptions"
  , "node-process"
  , "ordered-collections"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
