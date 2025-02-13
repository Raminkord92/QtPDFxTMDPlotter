#ifndef PDFINFOMODEL_H
#define PDFINFOMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <vector>
#include "PDFInfo.h"

class PDFInfoModel : public QAbstractListModel
{
    Q_OBJECT
    Q_ENUMS(PDFRoles)

public:
    enum PDFRoles {
        PdfSetNameRole = Qt::UserRole + 1,
        MuMaxRole,
        MuMinRole
    };
    explicit PDFInfoModel(QObject *parent = nullptr);

signals:

public:
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    Q_INVOKABLE  void setPDFList(const QVariantList &list);
    Q_INVOKABLE QVariantMap get(int index) const {
        QVariantMap result;
        if (index >= 0 && index < m_pdfList.size()) {
            QModelIndex modelIndex = createIndex(index, 0);
            result["pdfSetName"] = data(modelIndex, PdfSetNameRole);
            result["muMax"] = data(modelIndex, MuMaxRole);
            result["muMin"] = data(modelIndex, MuMinRole);
        }
        return result;
    }
private:
    std::vector<PDFInfo> m_pdfList;
};

#endif // PDFINFOMODEL_H
