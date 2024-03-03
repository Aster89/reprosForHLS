module ArchUpdates (ArchUpdates(..)) where

-- 3rd party modules
import Flow ((.>))
import Xmobar (Exec(..))
import XMonad.Prompt.Man (getCommandOutput)
import XMonad.Hooks.StatusBar.PP (wrap)

-- my modules
import Utils (withFont)

data ArchUpdates = ArchUpdates deriving (Read, Show)

instance Exec ArchUpdates where
  rate = undefined
  run = const (getCommandOutput "checkupdates") .> fmap (lines .> length .> makeMessage)

makeMessage :: Int -> String
makeMessage n = case n of
    0 -> greenApple ++ green "system up to date"
    1 -> redApple ++ yellow "1 update available"
    _ -> redApple ++ yellow (show n ++ " updates available")
  where
    yellow = wrap "<fc=yellow>" "</fc>"
    green = wrap "<fc=green>" "</fc>"
    greenApple = "\x1f34f" `withFont` 4 -- 🍏
    redApple = "\x1f34e" `withFont` 4 -- 🍎
