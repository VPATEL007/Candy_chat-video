package com.randomvideochat.flutter_files_picker.filepicker.local.filter.callback;


import com.randomvideochat.flutter_files_picker.filepicker.local.filter.entity.BaseFile;
import com.randomvideochat.flutter_files_picker.filepicker.local.filter.entity.Directory;

import java.util.List;

/**
 * Created by Vincent Woo
 * Date: 2016/10/11
 * Time: 11:39
 */

public interface FilterResultCallback<T extends BaseFile> {
    void onResult(List<Directory<T>> directories);
}
