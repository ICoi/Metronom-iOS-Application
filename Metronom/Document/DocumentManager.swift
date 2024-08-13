//
//  DocumentManager.swift
//  Metronom
//
//  Created by 정다운 on 8/12/24.
//

import UIKit

class DocumentManager {
    init() {
        createFolder()
    }
    
    /// 오디오 파일이 저장된 경로를 획득합니다
    var getPath: URL? {
        get {
            guard let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
                return nil
            }
            let docURL = URL(string: documentsDirectory)!
            let dataPath = docURL.appendingPathComponent("RecordAudio")
            return dataPath
        }
    }
    
    /// 오디오 파일을 저장할 경로를 생성합니다.
    private func createFolder() {
        guard let folderPath = getPath?.path else { return }
        
        if !FileManager.default.fileExists(atPath: folderPath) {
            do {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
                
                print("create folder")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func listFiles() -> [String] {
        let fileManager = FileManager.default
        guard let path = getPath?.path else { return [] }
        
        // 폴더가 존재하는지 확인
        var isDirectory: ObjCBool = false
        if !fileManager.fileExists(atPath: path, isDirectory: &isDirectory) || !isDirectory.boolValue {
            print("지정된 경로가 디렉토리가 아니거나 존재하지 않습니다.")
            return []
        }
        
        do {
            // 폴더 안의 파일 리스트를 얻음
            let fileURLs = try fileManager.contentsOfDirectory(atPath: path)
            return fileURLs
        } catch {
            print("파일 목록을 가져오는 데 오류가 발생했습니다: \(error.localizedDescription)")
            return []
        }
    }
}
