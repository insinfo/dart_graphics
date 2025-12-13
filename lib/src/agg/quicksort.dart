import 'rasterizer_cells_aa.dart';

/// QuickSort implementation optimized for PixelCellAa arrays
/// Used by the rasterizer for sorting cells by X coordinate
class QuickSortCellAa {
  QuickSortCellAa();

  /// Sorts the entire array of cells
  void sort(List<PixelCellAa> dataToSort) {
    if (dataToSort.isEmpty) return;
    _sort(dataToSort, 0, dataToSort.length - 1);
  }

  /// Sorts cells in the given range [beg, end]
  void sortRange(List<PixelCellAa> dataToSort, int beg, int end) {
    if (beg >= end) return;
    _sort(dataToSort, beg, end);
  }

  void _sort(List<PixelCellAa> dataToSort, int beg, int end) {
    if (end == beg) {
      return;
    }
    
    int pivot = _getPivotPoint(dataToSort, beg, end);
    if (pivot > beg) {
      _sort(dataToSort, beg, pivot - 1);
    }

    if (pivot < end) {
      _sort(dataToSort, pivot + 1, end);
    }
  }

  int _getPivotPoint(List<PixelCellAa> dataToSort, int begPoint, int endPoint) {
    int pivot = begPoint;
    int m = begPoint + 1;
    int n = endPoint;
    
    while (m < endPoint && dataToSort[pivot].x >= dataToSort[m].x) {
      m++;
    }

    while (n > begPoint && dataToSort[pivot].x <= dataToSort[n].x) {
      n--;
    }
    
    while (m < n) {
      // Swap
      PixelCellAa temp = dataToSort[m];
      dataToSort[m] = dataToSort[n];
      dataToSort[n] = temp;

      while (m < endPoint && dataToSort[pivot].x >= dataToSort[m].x) {
        m++;
      }

      while (n > begPoint && dataToSort[pivot].x <= dataToSort[n].x) {
        n--;
      }
    }
    
    if (pivot != n) {
      PixelCellAa temp2 = dataToSort[n];
      dataToSort[n] = dataToSort[pivot];
      dataToSort[pivot] = temp2;
    }
    
    return n;
  }
}

/// QuickSort implementation for range adaptor with unsigned integers
/// Used for sorting indices by their values
class QuickSortRangeAdaptorUint {
  QuickSortRangeAdaptorUint();

  /// Sorts the entire range adaptor
  void sort(List<int> dataToSort) {
    if (dataToSort.isEmpty) return;
    _sort(dataToSort, 0, dataToSort.length - 1);
  }

  /// Sorts the range adaptor in the given range [beg, end]
  void sortRange(List<int> dataToSort, int beg, int end) {
    if (beg >= end) return;
    _sort(dataToSort, beg, end);
  }

  void _sort(List<int> dataToSort, int beg, int end) {
    if (end == beg) {
      return;
    }
    
    int pivot = _getPivotPoint(dataToSort, beg, end);
    if (pivot > beg) {
      _sort(dataToSort, beg, pivot - 1);
    }

    if (pivot < end) {
      _sort(dataToSort, pivot + 1, end);
    }
  }

  int _getPivotPoint(List<int> dataToSort, int begPoint, int endPoint) {
    int pivot = begPoint;
    int m = begPoint + 1;
    int n = endPoint;
    
    while (m < endPoint && dataToSort[pivot] >= dataToSort[m]) {
      m++;
    }

    while (n > begPoint && dataToSort[pivot] <= dataToSort[n]) {
      n--;
    }
    
    while (m < n) {
      // Swap
      int temp = dataToSort[m];
      dataToSort[m] = dataToSort[n];
      dataToSort[n] = temp;

      while (m < endPoint && dataToSort[pivot] >= dataToSort[m]) {
        m++;
      }

      while (n > begPoint && dataToSort[pivot] <= dataToSort[n]) {
        n--;
      }
    }
    
    if (pivot != n) {
      int temp2 = dataToSort[n];
      dataToSort[n] = dataToSort[pivot];
      dataToSort[pivot] = temp2;
    }
    
    return n;
  }
}
