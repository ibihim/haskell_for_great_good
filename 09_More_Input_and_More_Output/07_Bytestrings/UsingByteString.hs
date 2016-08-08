import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString as S

-- pack :: [Word8] -> ByteString

main = putStrLn $ show $ B.pack [0..255]