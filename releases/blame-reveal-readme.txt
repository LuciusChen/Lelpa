Display git blame information in the fringe with adaptive color gradients.
Color intensity based on commit recency within an intelligent time window.
Show commit info above each block with sticky headers.
Performance optimized: lazy loading, smart caching, and viewport rendering.

Key Features:
- Smart time-based commit selection with auto-calculation
- Gradient quality control (strict/auto/relaxed)
- Lazy loading for large files (configurable threshold)
- Incremental commit info loading with caching
- Recursive blame navigation with historical context
- Sticky headers for long commits
- Theme-aware color schemes with HSL customization
- Customizable display layouts (line/compact/full/none)

Quick Start:
  M-x blame-reveal-mode

Common Customizations:
  (setq blame-reveal-recent-days-limit 'auto)      ; Smart time window
  (setq blame-reveal-gradient-quality 'auto)       ; Balanced quality
  (setq blame-reveal-display-layout 'compact)      ; Header format
  (setq blame-reveal-color-scheme '(:hue 210 ...)) ; Color theme

See full documentation: https://github.com/lucius-chen/blame-reveal
