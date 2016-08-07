import System.Environment
import System.Directory
import System.IO
import Control.Exception
import Data.List

dispatch :: String -> [String] -> IO ()
dispatch "add"    = add
dispatch "view"   = view
dispatch "remove" = remove
dispatch command  = doesntExist command

doesntExist :: String -> [String] -> IO ()
doesntExist command _ = putStrLn $
    "The " ++ command ++ " commnad doesn't exist.\n" ++
    "Valid commands are:\n" ++
    "\tadd <file name> \"<Text>\"\n" ++
    "\tview <file name>\n" ++
    "\tremove <file name> <line number>"

main = do
    (command : argList) <- getArgs
    dispatch command argList

add :: [String] -> IO ()
add [fileName, todoItem] = appendFile fileName (todoItem ++ "\n")
add _ = putStrLn "The add command takes exactly two arguments"

view :: [String] -> IO ()
view [fileName] = do
    contents <- readFile fileName

    let todoTasks     = lines contents
        numberedTasks = zipWith (\n line -> show n ++ " - " ++ line)
                                [0..]
                                todoTasks

    putStr $ unlines numberedTasks
view _ = putStrLn "The view command takes exactly one argument"

remove :: [String] -> IO ()
remove [fileName, numberString] = do
    contents <- readFile fileName

    let number       = read numberString
        todoTasks    = lines contents
        removeTask   = todoTasks !! number
        newTodoItems = unlines $ delete removeTask todoTasks

    bracketOnError (openTempFile "." "temp")

        (\(tempName, tempHandle) -> do
            hClose tempHandle
            removeFile tempName)

        (\(tempName, tempHandle) -> do
            hPutStr tempHandle newTodoItems
            hClose tempHandle
            removeFile fileName
            renameFile tempName fileName)
remove _ = putStrLn "The remove command takes exactly two arguments"
