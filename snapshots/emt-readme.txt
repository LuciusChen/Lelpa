EMT provides Han word boundaries backed by jieba-rs.  It keeps the `emt'
package name and compatibility surface for existing users.  In `emt-mode',
it integrates with `find-word-boundary-function-table' so built-in word
motion commands like `forward-word' and `kill-word' become segmentation
aware for Chinese text.  Compatibility wrappers are retained for callers
that want EMT behavior without enabling the minor mode.
