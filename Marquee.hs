module Marquee (Marquee(..)) where

import Xmobar (Exec(..), tenthSeconds)
import Control.Monad.State.Strict (evalStateT, forever, get, liftIO, modify')

data Marquee = Marquee !String !String !Int !Int deriving (Read, Show)

instance Exec Marquee where
  alias (Marquee name _ _ _) = name
  start (Marquee _ text len rate) callback = evalStateT (forever update) $ cycle (' ':text)
    where
      update = do
        new <- get <* modify' tail
        liftIO $ do
          callback (take len new)
          tenthSeconds rate
