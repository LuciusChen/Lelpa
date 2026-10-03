Passages provides a lightweight note-taking system for PDFs and EPUBs.
Features:
- Seamless inline passages with precise anchors
- Preserves original text formatting from PDFs
- Compact format: ● [content] ⟦file|location⟧ (Pxx rendered via overlay)
- Optimized single-overlay rendering system
- Robust file path resolution with intelligent search
- JIT-based incremental rendering with forced synchronization
- Protected metadata with modification hooks
- Fast O(1) jumping using text properties and marker parsing
- Full citar-denote integration for bibliography management
- Denote integration for general notes
- Bidirectional navigation: PDF ↔ Notes
- Comprehensive debugging utilities

Architecture:
- `passages-mode': Minor mode for Org buffers (overlays, JIT-lock)
- `passages-doc-mode': Minor mode for PDF/EPUB buffers (keybindings)
