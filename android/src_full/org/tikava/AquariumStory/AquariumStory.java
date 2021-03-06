package org.tikava.AquariumStory;

import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;

import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.provider.DocumentsContract;
import android.util.Log;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class AquariumStory extends QtActivity
{
    public static native void fileSelected(String fileName);

    static final int REQUEST_OPEN_IMAGE = 1;

    private static AquariumStory m_instance;

    public AquariumStory()
    {
        m_instance = this;
    }

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onDestroy()
    {
        super.onDestroy();
    }

    static void openAnImage()
    {
        m_instance.dispatchOpenGallery();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK)
        {
            if(requestCode == REQUEST_OPEN_IMAGE)
            {
                String filePath = getRealPathFromURI(getApplicationContext(), data.getData());
                fileSelected(filePath);
            }
        }
        else
        {
            fileSelected("");
        }
    }

    private void dispatchOpenGallery()
    {
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.setType("image/*");
        startActivityForResult(intent, REQUEST_OPEN_IMAGE);
    }

    public String getRealPathFromURI(Context context, Uri contentUri)
    {
        Cursor cursor = null;
        String id = "";

        try
        {
            String filePath = "";

            if (contentUri.toString().contains("com.android.providers") == true)
            {
                String wholeID = DocumentsContract.getDocumentId(contentUri);
                id = wholeID.split(":")[1];
            }
            else
            {
                String[] ids = contentUri.toString().split("/");
                id = ids[ids.length - 1];
            }

            String[] column = { MediaStore.Images.Media.DATA };
            String sel = MediaStore.Images.Media._ID + "=?";
            cursor = context.getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                                           column, sel, new String[]{ id }, null);
            int columnIndex = cursor.getColumnIndex(column[0]);

            if (cursor.moveToFirst())
                filePath = cursor.getString(columnIndex);

            cursor.close();

            return filePath;
        }
        finally
        {
            if (cursor != null)
            {
                cursor.close();
            }
        }
    }
}
