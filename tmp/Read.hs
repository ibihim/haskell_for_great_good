import Control.Monad(when)

main = do testReads

testReads = do
    numberString <- getLine

    when (not $ null numberString) $ do
        let readValue = reads numberString :: [(Integer, String)]

        putStrLn $ show readValue
        testReads
