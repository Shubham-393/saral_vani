import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../models/transcript.dart';

class TranscriptHistoryScreen extends StatefulWidget {
  @override
  _TranscriptHistoryScreenState createState() => _TranscriptHistoryScreenState();
}

class _TranscriptHistoryScreenState extends State<TranscriptHistoryScreen> {
  List<Transcript> _transcripts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedLanguage = 'all';

  @override
  void initState() {
    super.initState();
    _loadTranscripts();
  }

  Future<void> _loadTranscripts() async {
    setState(() {
      _isLoading = true;
    });

    final transcripts = DatabaseService.getAllTranscripts();
    
    setState(() {
      _transcripts = transcripts.reversed.toList(); // Show newest first
      _isLoading = false;
    });
  }

  List<Transcript> _getFilteredTranscripts() {
    var filtered = _transcripts;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((transcript) =>
        transcript.originalText.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        transcript.simplifiedText.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Filter by language
    if (_selectedLanguage != 'all') {
      filtered = filtered.where((transcript) =>
        transcript.language == _selectedLanguage
      ).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transcript History'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTranscripts,
            tooltip: 'Refresh',
          ),
          if (_transcripts.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: _showClearAllDialog,
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search transcripts...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                SizedBox(height: 12),
                
                // Language Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all'),
                      SizedBox(width: 8),
                      _buildFilterChip('हिंदी', 'hi'),
                      SizedBox(width: 8),
                      _buildFilterChip('English', 'en'),
                      SizedBox(width: 8),
                      _buildFilterChip('বাংলা', 'bn'),
                      SizedBox(width: 8),
                      _buildFilterChip('தமிழ்', 'ta'),
                      SizedBox(width: 8),
                      _buildFilterChip('తెలుగు', 'te'),
                      SizedBox(width: 8),
                      _buildFilterChip('मराठी', 'mr'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Transcripts List
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _getFilteredTranscripts().isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _getFilteredTranscripts().length,
                        itemBuilder: (context, index) {
                          final transcript = _getFilteredTranscripts()[index];
                          return _buildTranscriptCard(transcript);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedLanguage == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedLanguage = value;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          SizedBox(height: 20),
          Text(
            _transcripts.isEmpty ? 'No transcripts yet' : 'No matching transcripts',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _transcripts.isEmpty
                ? 'Start listening to create your first transcript'
                : 'Try adjusting your search or filter criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptCard(Transcript transcript) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with timestamp and language
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getLanguageLabel(transcript.language),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  DateFormat('MMM dd, HH:mm').format(transcript.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            
            // Original Text
            if (transcript.originalText.isNotEmpty) ...[
              Text(
                'Original:',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                transcript.originalText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 12),
            ],
            
            // Simplified Text
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Simplified:',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    transcript.simplifiedText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer with confidence and actions
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                SizedBox(width: 4),
                Text(
                  'Confidence: ${(transcript.confidence * 100).round()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (transcript.hasISLAnimation) ...[
                  SizedBox(width: 12),
                  Icon(
                    Icons.accessibility_new,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'ISL Available',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                Spacer(),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () => _shareTranscript(transcript),
                  tooltip: 'Share',
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTranscript(transcript),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageLabel(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'हिंदी';
      case 'en':
        return 'English';
      case 'bn':
        return 'বাংলা';
      case 'ta':
        return 'தமிழ்';
      case 'te':
        return 'తెలుగు';
      case 'mr':
        return 'मराठी';
      default:
        return languageCode.toUpperCase();
    }
  }

  void _shareTranscript(Transcript transcript) {
    // TODO: Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share functionality coming soon!')),
    );
  }

  void _deleteTranscript(Transcript transcript) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Transcript'),
        content: Text('Are you sure you want to delete this transcript?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              DatabaseService.deleteTranscript(transcript.id);
              _loadTranscripts();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Transcript deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Transcripts'),
        content: Text('Are you sure you want to delete all transcripts? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              DatabaseService.clearAllTranscripts();
              _loadTranscripts();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All transcripts cleared')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
