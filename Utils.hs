module Utils (withFont) where

import XMonad.Hooks.StatusBar.PP (wrap)

withFont t n = wrap ("<fn=" ++ show n ++ ">") "</fn>" t
