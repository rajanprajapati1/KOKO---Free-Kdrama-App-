import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/koko_theme.dart';
import '../data/content_data.dart';
import '../data/api_service.dart';
import '../widgets/compact_poster.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  Timer? _debounce;
  String _currentQuery = '';
  
  List<KDramaContent> _topSearches = [];
  List<KDramaContent> _searchResults = [];
  
  bool _isLoadingTopSearches = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadTopSearches();
    
    // Auto focus the search field after initial render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _loadTopSearches() async {
    try {
      final results = await ApiService.getMostSearch();
      if (mounted) {
        setState(() {
          _topSearches = results;
          _isLoadingTopSearches = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingTopSearches = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    final trimmedQuery = query.trim();

    // If query is cleared
    if (trimmedQuery.isEmpty) {
      setState(() {
        _currentQuery = '';
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }

    // Still same query, do nothing
    if (trimmedQuery == _currentQuery) return;

    setState(() {
      _currentQuery = trimmedQuery;
      _isSearching = true; // Show loading indicator specifically for search
    });

    _debounce = Timer(const Duration(milliseconds: 600), () {
      _performSearch(trimmedQuery);
    });
  }

  Future<void> _performSearch(String query) async {
    try {
      final results = await ApiService.searchContent(query);
      if (mounted && _currentQuery == query) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
       if (mounted && _currentQuery == query) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showSearchResults = _currentQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: KokoColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search Bar Area ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                   // Back button maybe not needed if it's placed in a bottom nav, but good to have if pushed.
                   // Since user clicked search icon from home screen, it's pushed.
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: KokoColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: _onSearchChanged,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        cursorColor: KokoColors.primary,
                        decoration: InputDecoration(
                          hintText: 'Search for shows, movies...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 15),
                          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.4), size: 22),
                          suffixIcon: _currentQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                  child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.4), size: 20),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                showSearchResults ? 'Top Results' : 'Top Searches',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // ── Content Area ──
            Expanded(
              child: _buildBodyContent(showSearchResults),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(bool showSearchResults) {
    if (showSearchResults) {
      if (_isSearching) {
        return const Center(
          child: CircularProgressIndicator(color: KokoColors.primary),
        );
      }
      if (_searchResults.isEmpty) {
        return const Center(
          child: Text(
            "No results found.",
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        );
      }
      return _buildGrid(_searchResults);
    } else {
      if (_isLoadingTopSearches) {
        return const Center(
          child: CircularProgressIndicator(color: KokoColors.primary),
        );
      }
      if (_topSearches.isEmpty) {
        return const Center(
          child: Text(
            "No trending searches right now.",
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        );
      }
      return _buildGrid(_topSearches);
    }
  }

  Widget _buildGrid(List<KDramaContent> items) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.65,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        return CompactPoster(content: items[i]);
      },
    );
  }
}
