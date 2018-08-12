
Function Get-Folder($description)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = $description
    $foldername.rootfolder = "MyComputer"
    $folder = ""
    if($foldername.ShowDialog() -eq "OK") {
        $folder = $foldername.SelectedPath
    }
    return $folder
}

$inputPath = Get-Folder -description "Select engine-3d diretory";
$inputPath = $inputPath.Replace("\", "\\");

$outputPath = Get-Folder -description "Select output directory";
$outputPath = $outputPath.Replace("\", "\\");

$content = @"
{
    // ʹ�� IntelliSense �˽�������ԡ� 
    // ��ͣ�Բ鿴�������Ե�������
    // ���˽������Ϣ�������: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "type": "node",
            "request": "launch",
            "name": "��������",
            "program": "`${workspaceFolder}\\out\\index.js",
            "args": [
                "$inputPath\\lib",
                "$outputPath\\lib",
                "..\\index.js"
            ],
            "outFiles": [
                "`${workspaceFolder}/**/*.js"
            ]
        }
    ]
}
"@

[System.IO.File]::WriteAllLines(".vscode/launch.json", $content)

function copyDir($relativePath) {
    &Robocopy.exe $inputPath/$relativePath $outputPath/js/$relativePath /e
}

function copyFile($fileName, $relativePath = ".") {
    &Robocopy.exe $inputPath/$relativePath $outputPath/js/$relativePath $fileName
}

copyDir "examples"
copyDir "script"
copyDir "tests"
copyFile "package.json"
copyDir "lib\builtin\effects"
copyDir "lib\renderer\shaders"
&Robocopy.exe .\resource\engine-3d-ts $outputPath /e

Write-Host "Finished."

Read-Host "Press ENTER to exit"