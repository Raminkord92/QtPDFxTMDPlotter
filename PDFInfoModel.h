#ifndef PDFINFOMODEL_H
#define PDFINFOMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <vector>
#include "PDFInfo.h"
#include "Utils.h"
#include "PDFSetProvider.h"

class PDFInfoModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum PDFRoles {
        PdfSetNameRole = Qt::UserRole + 1,
        QMaxRole,
        QMinRole,
        XMinRole,
        XMaxRole,
        NumMembersRole,
        FlavorsRole,
        FormatRole,
        OrderQCDRole
    };
    Q_ENUM(PDFRoles)

    explicit PDFInfoModel(QObject *parent = nullptr);

signals:

public:
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    // Q_INVOKABLE  void setPDFList(const QVariantList &list);
    Q_INVOKABLE void fillPDFInfoModel();
    Q_INVOKABLE void cLearModel();
    Q_INVOKABLE QVariantMap get(int index) const;
private:
    QVector<PDFInfo> m_pdfList;
    PDFSetProvider m_pdfSetProvider;
};

#endif // PDFINFOMODEL_H
